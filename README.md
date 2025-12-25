# 3_Road_adaptive_traffic_light_controller
An FSM-based adaptive traffic light controller designed in Verilog HDL that dynamically adjusts green signal timing based on traffic density while enforcing a maximum green limit to ensure fairness. The design is verified using Vivado simulation.
This project implements a 3-road Adaptive Traffic Light Controller using Verilog HDL. The controller is designed using a Finite State Machine (FSM) where each state represents a traffic signal phase (Green, Yellow, Red) for a particular road.

The system dynamically adjusts the green light duration based on real-time traffic density inputs. To ensure fairness and avoid road starvation, a maximum green time threshold is enforced so that no road can remain green indefinitely. Additionally, a waiting-time-based priority mechanism is used to ensure that roads with longer waiting times are eventually served.

The design is verified through a structured testbench simulation in Vivado, demonstrating correct timing behavior, adaptive control, and safe signal transitions. This project provides practical exposure to FSM design, timing control, and hardware-level modeling of real-world systems.
