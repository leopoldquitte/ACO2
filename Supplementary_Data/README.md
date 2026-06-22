# ACO2-ARG2 — Supplementary Data (MD)

Scripts and topologies for the all-atom MD of mitochondrial Aconitase 2 (ACO2),
in complex with ARG2 (bound) and alone (apo/unbound). The [4Fe-4S] cluster is
parametrized with a bonded model (MCPB.py / RESP).

## Layout

```
Supplementary_Data/
├── System_preparation/   SF4.in          MCPB.py input ([4Fe-4S] cluster)
│                         tleap_build.in  tleap assembly + solvation
├── MD_preparation/       mini1-4.in      4-stage minimization
│                         heat.in         heating 0->300 K
│                         eq_heavy/medium/free.in  NPT equilibration (restraint release)
│                         job_all.sh      SLURM driver (min -> heat -> equil)
└── MD/                   prod.in         1 us NPT production
                          disang.rest     Fe-S distance restraints
                          job_prod.sh     SLURM driver (production)
                          system_final.prmtop      topology, bound (ACO2-ARG2)
                          system_unbound.prmtop    topology, apo  (ACO2)
```

Workflow: QM (Gaussian 16) -> RESP -> MCPB.py (`SF4.in`) ->
`tleap_build.in` -> minimization/heating/equilibration (`MD_preparation/`) ->
production (`MD/prod.in`, 1 us).

Note: `prod.in` / `disang.rest` provided here are for the bound system
(atom indices 16057-16064). The apo run used the same restraint scheme on its
own indices (11408-11411 / 11404-11407), with `cut=9.0` and `barostat=2`.

## Software

Gaussian 16 (B3LYP/6-31G*, LanL2DZ on Fe) · AmberTools/MCPB.py ·
Amber24 PMEMD.cuda · ff14SB · TIP3P
