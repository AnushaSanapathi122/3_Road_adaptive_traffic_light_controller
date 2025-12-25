`timescale 1s / 1ms
// --------------------------------------------------
// Testbench for Adaptive Traffic Light Controller
// --------------------------------------------------

module traffic_L_CTb;

    reg clk;
    reg reset;
    reg [1:0] traffic_A, traffic_B, traffic_C;

    wire A_red, A_yellow, A_green;
    wire B_red, B_yellow, B_green;
    wire C_red, C_yellow, C_green;

    traffic_L_C DUT (
        .clk(clk),
        .reset(reset),
        .traffic_A(traffic_A),
        .traffic_B(traffic_B),
        .traffic_C(traffic_C),
        .A_red(A_red), .A_yellow(A_yellow), .A_green(A_green),
        .B_red(B_red), .B_yellow(B_yellow), .B_green(B_green),
        .C_red(C_red), .C_yellow(C_yellow), .C_green(C_green)
    );

    // ----------- 1 Hz CLOCK -----------
    initial clk = 0;
    always #0.5 clk = ~clk;

    initial begin
        reset = 1;
        traffic_A = 2'b10;
        traffic_B = 2'b00;
        traffic_C = 2'b00;
        #2;
        reset = 0;

// CASE 2: A HIGH (just over 1 round)
traffic_A = 2'b10;
traffic_B = 2'b00;
traffic_C = 2'b00;
#20;

// CASE 3: B HIGH
traffic_A = 2'b00;
traffic_B = 2'b10;
traffic_C = 2'b00;
#20;

// CASE 4: C HIGH
traffic_A = 2'b00;
traffic_B = 2'b00;
traffic_C = 2'b10;
#20;

// CASE 5: All HIGH
traffic_A = 2'b10;
traffic_B = 2'b10;
traffic_C = 2'b10;
#30;

$finish;

    end

    always @(posedge clk) begin
        $display(
            "T=%0t | A=%s | B=%s | C=%s | state=%0d timer=%0d",
            $time,
            A_green ? "GREEN" : A_yellow ? "YELLOW" : "RED",
            B_green ? "GREEN" : B_yellow ? "YELLOW" : "RED",
            C_green ? "GREEN" : C_yellow ? "YELLOW" : "RED",
            DUT.state,
            DUT.timer
        );
    end

endmodule
