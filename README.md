# Multi-Layer Perceptron VLSI Design

Full custom design of a multi-layer perceptron (MLP) hardware accelerator implemented in **Cadence Virtuoso** using a FinFET process node (20 nm gate length). All cells are captured as schematics with SPICE netlists exported for HSPICE simulation, and selected cells include physical layouts and post-layout verification.

---

## Project Overview

This project implements the core arithmetic and logic building blocks required to realize a binary-weight multi-layer perceptron in silicon. Starting from primitive standard cells (INV, NAND2, NOR, XOR/XNOR) the design is composed hierarchically up to a 2-bit **Multiplier** and a **Neuron** block, matching the computational requirements of a 1-bit weight, 1-bit activation MLP inference engine.

The design library is named **ECE555** and targets a FinFET technology with the following key transistor parameters:

| Parameter | Value |
|-----------|-------|
| Gate length (L) | 20 nm |
| Min fin width (nfin=1) | 27 nm |
| Technology | FinFET (nmos_rvt / pmos_rvt, nmos_lvt / pmos_lvt) |
| Supply (VDD) | Nominal FinFET supply |

---

## Repository Structure

```
Multi-layer-perceptron-VLSI-design/
│
├── INV/                  – Inverter (primitive)
├── INV_2bit/             – 2-bit wide inverter bus
├── NAND2/                – 2-input NAND gate
├── NOR/                  – 2-input NOR gate
├── NOR2/                 – Alternate NOR2 implementation
├── AND2/                 – 2-input AND gate (NAND2 + INV)
├── AND2_FO4/             – AND2 with fan-out-of-4 drive (AND2 + 4×INV)
├── AND2_ADD/             – AND2 variant used in adder path
├── XOR/                  – 2-input XOR gate
├── XNOR_TG/              – XNOR via transmission-gate topology
├── XNOR_TG_badlayout/    – XNOR_TG with intentionally bad layout (DRC study)
├── MUX2_1/               – 2-to-1 multiplexer (1-bit)
├── MUX2_1_3bit/          – 2-to-1 multiplexer (3-bit bus)
├── NAND_MUX/             – NAND-based MUX cell
├── INV_ADD/              – Inverter variant for adder path
├── INV_MUX/              – Inverter variant for MUX path
├── Adder_2bit/           – 2-bit ripple-carry adder
├── Adder_3bit/           – 3-bit ripple-carry adder
├── Multiplier/           – 2-bit × 1-bit binary multiplier (top-level arithmetic block)
├── NEURON/               – Complete neuron block (MAC + activation)
├── NOR2_badlayout/       – NOR2 with intentionally bad layout (layout study)
├── layout_old/           – Archived / reference layout cell
└── skel/                 – Skeleton layout template
```

Each cell directory contains one or more of:

| Subdirectory | Contents |
|---|---|
| `schematic/` | Cadence Virtuoso schematic (`.oa`) + thumbnail |
| `symbol/` | Virtuoso symbol view (`.oa`) + thumbnail |
| `layout/` | Full-custom layout (`.oa`) + thumbnail |
| `maestro/` | Maestro ADE simulation state and history |
| `*.sp` | HSPICE netlist exported from schematic |
| `test-*.sp` | HSPICE testbench / stimulus file |
| `*.tr0`, `*.ic0`, `*.st0` | HSPICE simulation waveform output files |

---

## Cell Descriptions

### Primitive Gates

#### `INV` — Inverter
Single-stage CMOS inverter. Two sizing variants appear across the library:
- **Min-size** (`nmos_lvt` nfin=1, `pmos_lvt` nfin=2, W=27/54 nm) — used inside XNOR_TG
- **Standard** (`nmos_lvt` nfin=2, `pmos_lvt` nfin=3, W=54/81 nm) — used in AND2 and adder paths

Includes schematic, symbol, layout, and Maestro simulation.

#### `INV_2bit` — 2-bit Inverter Bus
Two parallel INV instances sharing a common cell boundary, inverting a 2-bit bus `in<1:0>` → `out<1:0>`.

#### `NAND2` — 2-input NAND
Series pull-down (2 NMOS in series, nfin=2–4) and parallel pull-up (2 PMOS, nfin=3). RVT devices. Sizing varies by context (nfin=3/4 in AND2 path; nfin=2 in Multiplier path).

#### `NOR` / `NOR2` — 2-input NOR
Parallel pull-down (2 NMOS, nfin=3) and series pull-up (2 PMOS, nfin=6 — double-sized to restore drive strength). `NOR2` is an alternate sizing or iteration; `NOR2_badlayout` is provided as a layout exercise with intentional DRC violations.

#### `XOR` — 2-input XOR
Built from standard CMOS gates in Virtuoso schematic; symbol and schematic views only.

#### `XNOR_TG` — Transmission-Gate XNOR
Compact 8-transistor XNOR using transmission gates (pass transistors). All devices are minimum-size FinFET (nfin=1, W=27 nm).

```
Topology: two cross-coupled TG pairs controlled by in0/in1 and their complements,
          producing out = !(in0 XOR in1)
```

`XNOR_TG_badlayout` contains the same schematic with an intentionally rule-violating layout for design-rule-check (DRC) learning purposes.

---

### Composite / Arithmetic Cells

#### `AND2` — 2-input AND
```
AND2 = NAND2 → INV
```
Schematic-only (no standalone layout; layout resides inside parent cells).

#### `AND2_FO4` — AND2 with Fan-Out of 4
```
AND2_FO4 = AND2 → { INV×4 }
```
Used to characterize AND2 drive strength under a fan-out-of-4 load, a standard cell characterization benchmark.

#### `AND2_ADD` — AND2 (Adder Variant)
AND2 customized for integration into the adder carry path; includes a layout view.

#### `MUX2_1` — 2-to-1 Multiplexer (1-bit)
Single-bit 2-to-1 MUX. Schematic and symbol views.

#### `MUX2_1_3bit` — 2-to-1 Multiplexer (3-bit)
Three parallel MUX2_1 instances forming a 3-bit wide bus multiplexer.

#### `NAND_MUX` — NAND-based MUX
Multiplexer variant implemented using NAND logic for potentially improved timing in the critical path.

#### `INV_ADD` / `INV_MUX` — Buffered Inverter Variants
Inverter cells sized and placed specifically for use in adder and MUX signal paths, with full layouts included.

#### `Adder_2bit` — 2-bit Ripple-Carry Adder
Computes the 2-bit sum of two 1-bit inputs plus carry, building up from the primitive gates. Schematic and symbol views.

#### `Adder_3bit` — 3-bit Ripple-Carry Adder
Extends the 2-bit adder to handle 3-bit sums, required for the neuron accumulation path.

---

### Top-Level Blocks

#### `Multiplier` — 2-bit Binary Multiplier

The core arithmetic block of the MLP inference engine. Computes the **1-bit × 1-bit product** for two weight/activation pairs and produces a 2-bit result `n<1:0>`.

```
Inputs:  x0, x1  (activation bits)
         w0, w1  (weight bits)
Outputs: n<0>, n<1>  (2-bit product)

Internal logic:
  n<0> = ~(x0 & w0)  via NAND2 + INV
  n<1> = XNOR(x1, w1) NOR NAND(x0, w0)
```

Devices: NAND2, INV, XNOR_TG, NOR (all RVT FinFET, 20 nm).
Simulation files: `Multiplier.sp`, `test-multi.sp`, waveform outputs `.tr0/.ic0/.st0/.pa0`.

#### `NEURON` — MLP Neuron

Top-level neuron cell that integrates the multiplier array with accumulation and activation logic to form a single neuron of the multi-layer perceptron. Schematic view only (no exported SPICE — referenced hierarchically from parent).

---

## Design Methodology

1. **Schematic Capture** — All cells drawn in Cadence Virtuoso Schematic Editor.
2. **SPICE Simulation** — Netlists exported in HSPICE format and simulated in Maestro ADE; transient and DC sweep results stored in `*.tr0 / *.ic0 / *.st0` files.
3. **Symbol Creation** — Black-box symbols created for each cell to enable hierarchical composition.
4. **Physical Layout** — Select cells (`INV`, `AND2_ADD`, `INV_ADD`, `INV_MUX`, `NOR2`, `XNOR_TG`) have full-custom layouts drawn in Virtuoso Layout Editor.
5. **Layout Studies** — `NOR2_badlayout` and `XNOR_TG_badlayout` contain intentionally incorrect layouts used to study DRC violations and layout best practices.

---

## Tools & Environment

| Tool | Purpose |
|------|---------|
| Cadence Virtuoso | Schematic capture, layout, LVS/DRC |
| HSPICE (Synopsys) | SPICE simulation (via Maestro ADE) |

---

## Getting Started

1. **Open in Virtuoso**: Import the `cdsinfo.tag` and `data.dm` files into a Cadence library manager session. The library name is `ECE555`.
2. **Run Simulations**: Open a cell's `maestro/` state in ADE Maestro to re-run pre-configured HSPICE simulations.
3. **View Netlists**: All exported SPICE netlists (`*.sp`) can be opened with any text editor and simulated standalone with HSPICE or ngspice.
4. **Layout Review**: Open cells with a `layout/` directory in Virtuoso Layout Editor to inspect the physical design.

---

## Authors

Authors: Munasib Ilham, M Sadman Sakib, Kyle Bartel, Rex White

ECE 555 — Digital Circuits and Components, University of Wisconsin–Madison  
Design files generated: October–November 2025
