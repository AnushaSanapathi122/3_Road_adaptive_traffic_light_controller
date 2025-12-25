# 🚦 Adaptive Traffic Light Controller (Verilog HDL)

## 📌 Project Overview
This project implements a **3-road Adaptive Traffic Light Controller** using **Verilog HDL**.  
The controller dynamically adjusts traffic signal timings based on traffic density while ensuring fairness so that no road remains green indefinitely.

The design is based on a **Finite State Machine (FSM)** and is verified through simulation using **Vivado**.

---

## 🎯 Objectives
- Design a traffic light controller using FSM concepts
- Adapt green signal duration based on traffic density
- Enforce a maximum green time to prevent road starvation
- Verify correct functionality through simulation

---

## 🧠 Concept Explanation
- Only **one road gets GREEN at a time**
- Each road follows the sequence **GREEN → YELLOW → RED**
- Green duration is adjusted based on traffic density:
  - Low traffic → shorter green
  - Medium traffic → moderate green
  - High traffic → longer green
- A **maximum green threshold** ensures fairness across all roads
- Roads waiting longer gradually gain priority
- Yellow signal provides a safe transition between green and red

This adaptive approach improves traffic flow while maintaining safety and fairness.


## ⚙️ Design Architecture
- **FSM States:**  
  A_G, A_Y, B_G, B_Y, C_G, C_Y  
- **Timer Counter:**  
  Controls how long each signal remains active  
- **Priority Logic:**  
  Combines traffic density and waiting time  
- **Output Logic:**  
  Ensures mutually exclusive GREEN, YELLOW, and RED signals  


## ⏱️ Timing Parameters
The controller uses configurable timing parameters to control signal durations.

For simulation, reduced timing values are used to clearly observe FSM behavior and adaptive control within a short simulation time.  
For real-world operation, these timing values can be scaled appropriately **without changing the controller logic**.

## 🧪 Simulation & Verification

### Simulation Setup
- Tool: **Vivado Simulator**
- Clock: **1 Hz (1 second per clock cycle)**
- Traffic conditions applied through a structured testbench

### Test Scenarios
- All roads with low traffic  
- Individual roads with high traffic  
- All roads with high traffic  

### Simulation Results
- Only **one road is GREEN or YELLOW at any time**
- Green duration adapts correctly based on traffic density
- Green signal **never exceeds the maximum green limit**
- Yellow signal appears for the configured duration
- Roads switch fairly without starvation
- FSM transitions and timer behavior are correct

The simulation waveforms validate the correctness and adaptive nature of the controller.
<img width="1596" height="849" alt="Screenshot 2025-12-25 104420" src="https://github.com/user-attachments/assets/7e45e3c8-d43d-407b-a16b-573f3d68edb3" />


## 🛠️ Tools Used
- Verilog HDL
- Vivado (Simulation)
- GitHub (Version Control)
- 

## 📚 Learning Outcomes
- FSM-based system design
- Timing control using counters
- Adaptive control logic implementation
- Testbench creation and debugging
- Hardware modeling of real-world systems


## 🚀 Future Enhancements
- Real-time sensor-based traffic detection
- Pedestrian crossing support
- Emergency vehicle priority handling
- FPGA hardware implementation


