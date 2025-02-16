
# **FPGA-Based UART Implementation using Verilog (Xilinx Vivado)**  

This repository contains a **Universal Asynchronous Receiver-Transmitter (UART) system** implemented using **Verilog** and deployed on an **FPGA** using **Xilinx Vivado**. The project is designed to establish **serial communication** between an FPGA and external devices like microcontrollers, PCs, or embedded systems.  

## **Project Overview**  
UART is a widely used serial communication protocol that facilitates full-duplex data transfer with minimal overhead. In this project, a fully functional **UART transmitter and receiver** are implemented and tested on **FPGA hardware**. The design includes:  

✅ **FPGA Hardware Implementation** – The design is not just simulated but also tested on a real FPGA.  
✅ **Modular Verilog Design** – Structured and reusable code for clarity and scalability.  
✅ **Configurable Baud Rate Generator** – Supports flexible baud rate selection for reliable communication.  
✅ **Real-Time Data Transmission & Reception** – Ensures seamless communication with external devices.  
✅ **Tested in Xilinx Vivado** – Simulation and synthesis performed using Xilinx tools.  

---

## **Project Structure**  
```
├── src/                  
│   ├── uart_top.v        # Top-level module integrating all components  
│   ├── baud_rate_gen.v   # Baud rate generator for timing control  
│   ├── uart_tx.v         # UART transmitter  
│   ├── uart_rx.v         # UART receiver  
│   ├── testbenches/      # Testbenches for verification  
│   └── constraints/      # FPGA constraints file (XDC)  
├── simulations/          # Simulation results and waveform analysis  
├── hardware_testing/     # FPGA implementation results  
└── README.md             # Project documentation  
```  

---

## **Implementation Details**  
- **FPGA Used:** (Specify your FPGA board, e.g., Basys 3, Artix-7, etc.)  
- **Development Environment:** Xilinx Vivado  
- **Language:** Verilog  
- **Baud Rate:** (Specify the default baud rate used, e.g., 9600 bps, 115200 bps, etc.)  
- **Simulation & Verification:** Functional verification using Xilinx Vivado’s simulator and real hardware testing.  

---

## **Modules & Functionality**  
### **1️⃣ Top Module (`uart_top.v`)**  
- Integrates the baud rate generator, transmitter, and receiver.  
- Provides a unified interface for UART communication.  

### **2️⃣ Baud Rate Generator (`baud_rate_gen.v`)**  
- Generates clock pulses for data transmission and reception.  
- Supports multiple baud rates for flexible communication.  

### **3️⃣ UART Transmitter (`uart_tx.v`)**  
- Converts parallel input data into a serial stream.  
- Implements start, stop, and data bits for correct transmission.  

### **4️⃣ UART Receiver (`uart_rx.v`)**  
- Captures incoming serial data and converts it into parallel format.  
- Synchronizes with the baud clock to decode received bits accurately.  

---

## **Future Enhancements**  
🔹 Implement **FIFO Buffers** to manage data efficiently.  
🔹 Add **Parity Bit & Error Detection** for more robust communication.  
🔹 Extend to **SPI/I2C/UART Hybrid Communication** for broader applications.  
🔹 Create a **Graphical Interface (Python-based)** for easy testing on a PC.  

---

## **Conclusion**  
This project provides a **fully functional, FPGA-based UART system**, making it a **valuable resource for FPGA designers, embedded system engineers, and students** working on digital communication. By implementing and testing this UART on **real hardware**, the design is validated for practical applications in embedded systems and **VLSI projects**.  
