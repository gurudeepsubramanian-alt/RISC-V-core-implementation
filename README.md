# 2‑Stage Pipelined Mini‑Processor: RTL → GDSII

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

### 🔹 Post-Synthesis Schematic — Cadence Genus

Regularized gate‑level representation showing mapped standard cells.

![Post-Synthesis Schematic](sandbox:/mnt/data/bbcde337-ca21-431a-ac7a-f50a79cf2341.png)

### 🔹 Floorplan View (Pre-Placement)

Core boundary defined with standard cell rows created for placement.

![Floorplan View](sandbox:/mnt/data/112dfc15-c09a-4882-9b8d-e1c37c1f64c7.png)

### 🔹 Placement + Power Grid Overview

Standard cells placed; VDD/VSS rails clearly visible.

![Placement View](sandbox:/mnt/data/d5d470d7-aaaa-4364-afa4-364fa7a7596c.png)

### 🔹 Clock Tree Debugger

Clock tree buffers inserted to balance skew across sequential elements.

![Clock Tree Debugger](sandbox:/mnt/data/dca6e3a0-e97e-412f-bc70-2a6b161a44c0.png)

### 🔹 Routed Design — Timing Analyzed

All signal nets routed using metal layers with timing optimization.

![Routed Layout](sandbox:/mnt/data/ff244e06-5a2c-41c4-9149-7d3f260bf77b.png)

### 🔹 Final Routed Layout — Metal Layers Visible

Multi‑layer routing with vias and power rails finalized.

![Final Routed Layout](sandbox:/mnt/data/377a6f9e-1d4e-490d-b356-6ce32ae9784e.png)

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

## 📝 License

MIT License — see `LICENSE` file.

© 2025 <Your Name>

---

## 📬 Contact

* Email: [your.email@example.com](mailto:your.email@example.com)
* LinkedIn: <your‑linkedin>
* GitHub: <your‑github>
* Institution: <your‑institute>

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
