`timescale 1s / 1ms
// --------------------------------------------------
// Adaptive Traffic Light Controller (3 Roads)
// --------------------------------------------------

module traffic_L_C (

    input  wire clk,
    input  wire reset,

    input  wire [1:0] traffic_A,
    input  wire [1:0] traffic_B,
    input  wire [1:0] traffic_C,

    output reg A_red, A_yellow, A_green,
    output reg B_red, B_yellow, B_green,
    output reg C_red, C_yellow, C_green
);

    // ---------------- TIMING PARAMETERS ----------------
    parameter GREEN_LOW   = 5;
    parameter GREEN_MED   = 10;
    parameter GREEN_HIGH  = 20;
    parameter MAX_GREEN   = 20;
    parameter YELLOW_TIME = 3;

    // ---------------- FSM STATES ----------------
    parameter A_G = 3'd0, A_Y = 3'd1,
              B_G = 3'd2, B_Y = 3'd3,
              C_G = 3'd4, C_Y = 3'd5;

    reg [2:0] state, next_state;

    // ---------------- TIMER ----------------
    reg [6:0] timer;
    reg [6:0] green_time;

    // ---------------- WAITING TIME (AGING) ----------------
    reg [4:0] wait_A, wait_B, wait_C;

    // ---------------- PRIORITY ----------------
    reg [6:0] prio_A, prio_B, prio_C;
    reg [1:0] next_road;   // 0=A, 1=B, 2=C

    // ---------------- GREEN TIME SELECTION ----------------
    always @(*) begin
        case (state)
            A_G: green_time = (traffic_A == 2'b00) ? GREEN_LOW  :
                              (traffic_A == 2'b01) ? GREEN_MED  : GREEN_HIGH;
            B_G: green_time = (traffic_B == 2'b00) ? GREEN_LOW  :
                              (traffic_B == 2'b01) ? GREEN_MED  : GREEN_HIGH;
            C_G: green_time = (traffic_C == 2'b00) ? GREEN_LOW  :
                              (traffic_C == 2'b01) ? GREEN_MED  : GREEN_HIGH;
            default: green_time = YELLOW_TIME;
        endcase

        // Enforce maximum green limit
        if (green_time > MAX_GREEN)
            green_time = MAX_GREEN;
    end

    // ---------------- PRIORITY CALC ----------------
    always @(*) begin
        prio_A = traffic_A + wait_A;
        prio_B = traffic_B + wait_B;
        prio_C = traffic_C + wait_C;

        if (prio_A >= prio_B && prio_A >= prio_C)
            next_road = 2'd0;
        else if (prio_B >= prio_A && prio_B >= prio_C)
            next_road = 2'd1;
        else
            next_road = 2'd2;
    end

    // ---------------- NEXT STATE LOGIC ----------------
    always @(*) begin
        next_state = state;
        case (state)
            A_G: if (timer >= green_time) next_state = A_Y;
            A_Y: next_state = (next_road == 2'd1) ? B_G :
                              (next_road == 2'd2) ? C_G : A_G;

            B_G: if (timer >= green_time) next_state = B_Y;
            B_Y: next_state = (next_road == 2'd0) ? A_G :
                              (next_road == 2'd2) ? C_G : B_G;

            C_G: if (timer >= green_time) next_state = C_Y;
            C_Y: next_state = (next_road == 2'd0) ? A_G :
                              (next_road == 2'd1) ? B_G : C_G;
        endcase
    end

    // ---------------- SEQUENTIAL LOGIC ----------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state  <= A_G;
            timer  <= 0;
            wait_A <= 0;
            wait_B <= 0;
            wait_C <= 0;
        end else begin
            state <= next_state;

            if (state != next_state)
                timer <= 0;
            else
                timer <= timer + 1;

            case (state)
                A_G: begin
                    wait_A <= 0;
                    if (wait_B < 31) wait_B <= wait_B + 1;
                    if (wait_C < 31) wait_C <= wait_C + 1;
                end
                B_G: begin
                    wait_B <= 0;
                    if (wait_A < 31) wait_A <= wait_A + 1;
                    if (wait_C < 31) wait_C <= wait_C + 1;
                end
                C_G: begin
                    wait_C <= 0;
                    if (wait_A < 31) wait_A <= wait_A + 1;
                    if (wait_B < 31) wait_B <= wait_B + 1;
                end
            endcase
        end
    end

    // ---------------- OUTPUT LOGIC ----------------
    always @(*) begin
        A_green = (state == A_G);
        A_yellow = (state == A_Y);
        B_green = (state == B_G);
        B_yellow = (state == B_Y);
        C_green = (state == C_G);
        C_yellow = (state == C_Y);

        A_red = ~(A_green | A_yellow);
        B_red = ~(B_green | B_yellow);
        C_red = ~(C_green | C_yellow);
    end

endmodule
