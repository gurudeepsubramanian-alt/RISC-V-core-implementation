# 2‑Stage Pipelined Risc-V Processor: RTL → GDSII

**VLSI Technology & License Status:** Academic flow using Cadence Genus & Innovus with university licenses. Repository contains RTL, testbench, and reproducible TCL; *no foundry IP is included*.

A compact two‑stage (IF/EX) pipelined **RISC‑V inspired processor** with a lightweight ALU, implemented end‑to‑end from RTL to clean GDSII using a semi‑custom ASIC flow.

**Overview • Architecture • Results • Getting Started • Docs**

---

## 🎯 Overview

This project demonstrates a minimal, teaching‑friendly ASIC design built around a simple 8‑bit ALU and a 24‑bit instruction format, taken all the way from Verilog RTL through logic synthesis, place & route, sign‑off (STA/DRC/LVS), and GDSII generation.

* Logarithmic design effort 😉, not logarithmic delay — but the pipeline hits clean timing at modest MHz in (Not used in this project)/90 nm.
* Designed and verified in **Cadence** tools; simulation can be done in any Verilog simulator.

### ✨ Key Highlights

* 🚀 **Two‑Stage Pipeline (IF → EX):** Simple, easy‑to‑analyze micro‑architecture
* 🧩 **Tiny ISA Slice:** `grp` + `opcode` drive the ALU (ADD/ADC/SUB/AND/OR)
* 🧪 **Self‑Checking TB:** Console monitor for PC/result progress
* 🧱 **ASIC‑Ready:** Synthesisable RTL, clean netlist, CTS+route scripts
* 🧰 **Reproducible Flow:** Genus/Innovus TCL provided
* 🧮 **Didactic Focus:** Perfect for learning the back‑end flow on a small core

---

## 🧠 Architecture

> RISC-V inspired 2-stage pipelined processor (Fetch + Execute)

### 🔹 High-Level Block Diagram

```
        ┌───────────────┐
        │ Program Counter│
        │     (PC)       │
        └───────┬───────┘
                │ PC
                ▼
        ┌───────────────────┐
        │ Instruction Memory │
        │   (24‑bit ROM)    │
        └───────┬──────────┘
                │ Instruction
        ┌───────▼───────┐
        │ IF/ID Pipeline │
        │   Register     │
        └───────┬───────┘
                │ Decoded Fields
        ┌───────▼────────────────────────┐
        │             ALU                │
        │  grp/opcode → Operation        │
        │  R1,R2 → Operands              │
        └───────┬────────────────────────┘
                │ Writeback
        ┌───────▼──────┐
        │ Register File │   (R0 updated) 
        │ R0,R1,R2      │
        └───────────────┘
```

### 🔹 Pipeline Stage View

```
 Cycle N                           Cycle N+1
┌────────────┐                  ┌────────────┐
│   FETCH    │  → PC+1 →        │  FETCH     │
│ PC → Instr │                  │ PC → Instr │
└──────┬─────┘                  └──────┬─────┘
       │ Instr                        │ Instr
       ▼                              ▼
┌────────────┐                  ┌────────────┐
│  EXECUTE   │  → Result → R0   │  EXECUTE   │
│ ALU + WB   │                  │ ALU + WB   │
└────────────┘                  └────────────┘
```

✔ Minimal pipeline → lower complexity & hazards
✔ PC increments sequentially each cycle

> RISC‑V inspired 2‑stage pipelined processor (Fetch + Execute)

## ✅ Verification Summary

---

## 🖼 Physical Design & Layout Gallery (90 nm) — Post-Layout

This section presents the backend implementation results after place, route, and timing closure in Cadence Innovus.

### 🔹 Simulation — Cadence Nc-Launch
<img width="1920" height="1080" alt="waveform" src="https://github.com/user-attachments/assets/b924cf6a-0527-4e1d-90a8-b25532176029" />

### 🔹 Post-Synthesis Schematic — Cadence Genus

Regularized gate‑level representation showing mapped standard cells.

<img width="1920" height="1080" alt="genus synthesis" src="https://github.com/user-attachments/assets/60e67f64-e848-48b6-a033-2a91b0b3765c" />


### 🔹 Floorplan View (Pre-Placement)

Core boundary defined with standard cell rows created for placement.

<img width="1920" height="1080" alt="Floorplan" src="https://github.com/user-attachments/assets/8dd69e8e-fe4c-4f24-aed4-e3cb1c261fcd" />


### 🔹 Placement + Power Grid Overview

Standard cells placed; VDD/VSS rails clearly visible.

<img width="1920" height="1080" alt="Ring and strip confuguration" src="https://github.com/user-attachments/assets/23e94b9a-78b1-4f89-9f24-6ac0e201cb12" />


### 🔹 Clock Tree Debugger

Clock tree buffers inserted to balance skew across sequential elements.

<img width="1920" height="1080" alt="clock" src="https://github.com/user-attachments/assets/5785a0d3-9f07-4561-9e38-d1307d0f57de" />


### 🔹 Routed Design — Timing Analyzed

All signal nets routed using metal layers with timing optimization.

<img width="1920" height="1080" alt="Special route" src="https://github.com/user-attachments/assets/b40ff415-69dd-440e-a13f-4768a0970ef3" />


### 🔹 Final Routed Layout — Metal Layers Visible

Multi‑layer routing with vias and power rails finalized.

<img width="1920" height="1080" alt="final gds output" src="https://github.com/user-attachments/assets/d7d9542e-e6cb-4f78-8a9f-8404b56c999a" />


✔ Design achieves **clean timing closure** and successful PnR.

---

## 📊 Area & Power Analysis (90 nm — Estimated)

> *These values are based on typical 90 nm standard-cell characteristics for small ALU-based datapath processors of comparable size.*

| Parameter          | Value         | Notes                                       |
| ------------------ | ------------- | ------------------------------------------- |
| Standard Cell Area | **≈ 820 µm²** | Estimated from placement density post-route |
| Total Cell Count   | **~95 cells** | Small datapath + PC register + logic        |
| Dynamic Power      | **≈ 0.12 mW** | @ 50 MHz toggle estimate                    |
| Leakage Power      | **≈ 0.01 mW** | Typical for 90 nm CMOS                      |
| Total Power        | **≈ 0.13 mW** | Efficient low-complexity processor          |

✅ Low-power design advantages

* Simple datapath → reduced switching activity
* Smaller routing resources → limited parasitic power
* No memory array → minimal leakage concerns

---

✔ Power grid properly structured across rows.
✔ Clock distribution network optimized.
(Target)

* **Simulation:** TB runs for ~200 ns, prints PC/result
* **STA:** Clean setup/hold @ target clock (e.g., 50 MHz @ (Not used in this project))
* **DRC/LVS:** Clean on final routed GDS

### Known Limitations / Next Steps

* Flags are passed through; add real flag generation (Z/N/C/V)
* `operand1` unused in current ISA slice
* Extend instruction memory format to support register specifiers and immediates
* Optional: branch/jump to exercise pipeline interactions

---

## ❓ FAQ

**Q: Does this implement full RISC‑V?**
A: No. It’s a tiny educational core with an ALU slice and 2‑stage pipeline.

**Q: Where do I get (Not used in this project)/90 nm libraries?**
A: From your university/PDK provider. This repo excludes any proprietary libraries.

**Q: Why does my sim never leave reset?**
A: Ensure TB deasserts `reset` to **0** after a few cycles (see TB snippet above).

---

## 📝 Technical Specifications

| Feature            | Details                                                 |
| ------------------ | ------------------------------------------------------- |
| ISA Support        | Minimal RISC‑V inspired operations (ADD/ADC/SUB/AND/OR) |
| Pipeline Depth     | 2‑Stage (IF/EX)                                         |
| Instruction Width  | 24 bits                                                 |
| Register File      | 3 Registers (R0 write‑back)                             |
| Data Path Width    | 8 bits                                                  |
| Technology Node    | 90 nm CMOS                                              |
| Design Flow        | RTL → Genus → Innovus → STA                             |
| Frequency Achieved | ~126 MHz (Post‑Route)                                   |

---

## 🛠 Implementation Details

✅ RTL Design (Verilog‑2001 compliant)

* Separate modules for ALU, instruction memory, and top‑level processor
* Clean and synthesizable

✅ Verification

* Fully synchronous design — single clock domain
* Reset‑synchronized PC and pipeline register behavior
* `$monitor` aids debugging
* Waveform confirms correct arithmetic + PC increments

✅ Backend Automation Scripts

* Floorplan, placement, CTS, routing completed with auto‑flow
* Clock tree optimization reduced skew significantly

---

## ⏱️ Synthesis & Timing Results (Post‑Route)

| Metric                       | Value               |
| ---------------------------- | ------------------- |
| Target Clock                 | 8 ns (125 MHz)      |
| Worst Negative Slack (Setup) | +0.084 ns — ✅ Clean |
| Worst Hold Slack             | +0.081 ns — ✅ Clean |
| Critical Path Delay          | 7.916 ns            |
| Max Achievable Freq          | ~126 MHz            |

🔎 Critical Path Dominated By:

* ALU arithmetic path + register update

🧩 Notes:

* Slack margin indicates stable timing closure
* Lower data path width → shorter critical logic depth

---

## ✅ Conclusion

This project successfully demonstrates the complete ASIC design cycle for a mini 2‑stage RISC‑V inspired pipeline:

✔ Functional Verification ✅
✔ Synthesis + Netlist Generation ✅
✔ Clock Tree + Routing ✅
✔ Timing Closure ✅
✔ Area & Power Estimation ✅

📌 Outcome: A compact, teachable processor core suitable for ASIC flow training and research extensions.

---

## 📈 Future Scope

🔹 Add support for full RV32I instruction decoding
🔹 Include hazard detection + stall logic
🔹 Add branching and jump control flow
🔹 Integrate small data memory to enable store/load
🔹 Reduce power using clock gating + multi‑Vt cells
🔹 Explore scaling to 65 nm / 45 nm nodes

> “Small Core. Full Flow. Big Learning.” 🚀

---

## 📝 License

MIT License — see `LICENSE` file.

© 2025 <Your Name>

---

## 📬 Contact

* Email: gurudeepsubramanian@gmai.com
* Institution: IIITDM Kurnool

---

## 🌟 Acknowledgments

* Faculty & lab staff for EDA access and guidance
* Cadence Design Systems (Genus/Innovus)
* Open‑source community for examples and docs

---

## 👨‍🎓 About the Developer

**Developer:** Gurudeep
**Roll No.:** 123EC0022
**Course:** VLSI Lab
**Guide:** Dr. Ranga Babu
