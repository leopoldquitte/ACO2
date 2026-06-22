# ACO2-ARG2 — Molecular dynamics input files

Input scripts and topologies for the all-atom MD simulations of mitochondrial
Aconitase 2 (ACO2), in complex with ARG2 and in its apo form. The [4Fe-4S]
cluster is described with a bonded model (MCPB.py / RESP).

## Contents

**System_preparation/**
- `SF4.in` — MCPB.py input for the [4Fe-4S] cluster parametrization
- `tleap_build.in` — tleap assembly: force fields, Cys–cluster bonds, solvation

**MD_preparation/**
- `mini1.in` – `mini4.in` — four-stage energy minimization
- `heat.in` — heating from 0 to 300 K
- `eq_heavy.in`, `eq_medium.in`, `eq_free.in` — NPT equilibration with progressive restraint release
- `job_all.sh` — SLURM driver (minimization → heating → equilibration)

**MD/**
- `prod.in` — 1 µs NPT production input
- `disang.rest` — distance restraints maintaining the [4Fe-4S] geometry
- `job_prod.sh` — SLURM driver (production)
- `system_final.prmtop` — topology of the ACO2–ARG2 complex
- `system_unbound.prmtop` — topology of the apo ACO2

## Software

Gaussian 16 · AmberTools / MCPB.py · Amber24 (PMEMD.cuda) · ff14SB · TIP3P
