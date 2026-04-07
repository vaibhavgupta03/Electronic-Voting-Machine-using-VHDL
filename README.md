# 🗳️ Electronic Voting Machine (EVM) using VHDL on ZedBoard

## 📌 Project Overview

This project implements a **simple Electronic Voting Machine (EVM)** using VHDL on the **ZedBoard FPGA (Zynq-7000)**.
The system allows users to cast votes for four candidates using push buttons and view the results on onboard LEDs.

---

## ⚙️ Features

* ✔️ Supports **4 candidates (A, B, C, D)**
* ✔️ **Two modes of operation**:

  * Voting Mode
  * Result Display Mode
* ✔️ **1 Hz clock divider** for reliable button sampling
* ✔️ **Edge detection logic** to avoid multiple counts per press
* ✔️ **Reset functionality** to clear all votes
* ✔️ Implemented and tested on **ZedBoard**

---

## 🧠 System Architecture

### 1. Clock Divider

* A separate module (`clock_1hzsync`) divides the input clock (e.g., 50 MHz)
* Generates a **slow clock (~1 Hz)**
* Used to:

  * Sample button inputs
  * Avoid bouncing effects (basic level)

---

### 2. Voting Logic

* Runs on the **slow clock**
* Detects **new button press (edge detection)** using previous state
* Increments vote count for selected candidate

---

### 3. Display Logic

* Displays vote count on **8 LEDs**
* Active only in **Result Mode**

---

### 4. Reset Logic

* Active-high reset
* Clears:

  * All vote counters
  * Previous button state

---

## 🔌 Inputs and Outputs

### Inputs

| Signal     | Description                        |
| ---------- | ---------------------------------- |
| `clk`      | System clock input                 |
| `reset`    | Reset button (active high)         |
| `mode`     | Mode select (0 = Vote, 1 = Result) |
| `btn[3:0]` | Candidate selection buttons        |

### Outputs

| Signal      | Description                   |
| ----------- | ----------------------------- |
| `leds[7:0]` | Displays vote count in binary |

---

## 🗳️ How to Use

### ✅ Voting Process

1. Set `mode = 0` (Voting Mode)
2. Press one of the buttons:

   * `btn[0]` → Candidate A
   * `btn[1]` → Candidate B
   * `btn[2]` → Candidate C
   * `btn[3]` → Candidate D
3. Each valid press increments the vote count by 1

⚠️ Hold press will NOT count multiple votes (edge detection applied)

---

### 📊 Checking Results

1. Set `mode = 1` (Result Mode)
2. Press a button to select candidate:

   * `btn[0]` → Show votes for A
   * `btn[1]` → Show votes for B
   * `btn[2]` → Show votes for C
   * `btn[3]` → Show votes for D
3. The vote count appears on LEDs in **binary format**

---

### 🔄 Resetting Votes

1. Press `reset = 1`
2. All vote counts reset to **0**
3. System returns to initial state

---

## 🧩 FPGA Implementation (ZedBoard)

### 🔗 Pin Configuration (XDC Highlights)

* Buttons connected to:

  * `T18, R18, R16, N15`

* LEDs connected to:

  * `U14, U19, W22, V22, U21, U22, T21, T22`

* Clock:

  * `Y9`

* Mode switch:

  * `F22`

* Reset:

  * `P16`

* All I/O standard:

  ```
  LVCMOS18
  ```

---

## 🛠️ Tools Used

* **VHDL**
* **Xilinx Vivado 2025.2**
* **ZedBoard (Zynq-7000 FPGA)**

---

## ⚠️ Limitations

* No advanced **button debouncing**
* Uses **derived slow clock** (not ideal for high-end FPGA design)
* Displays output in **binary (not human-readable decimal)**

---

## 🚀 Possible Improvements

* ✔️ Add **debouncing circuit**
* ✔️ Use **clock enable instead of slow clock**
* ✔️ Add **7-segment display output**
* ✔️ Add **LCD/OLED interface**
* ✔️ Store results in memory (non-volatile)

---

## 👨‍💻 Author

**Vaibhav Gupta**
Roll No: 25583009

---

## 📄 License

This project is for academic and learning purposes.
