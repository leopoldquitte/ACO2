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

Large derived inputs not tracked here (deposit alongside, e.g. Zenodo):
`SF4_final.frcmod`, `SF4_final.lib`, `system_ready.pdb`, coordinates/trajectories.

## Parameters as actually run (vs. manuscript)

The two systems were prepared independently; some settings differ between
bound and apo, and from the current Methods text. Report them explicitly.

| Parameter         | Bound (system_final)        | Apo (system_unbound)       | Manuscript        |
|-------------------|-----------------------------|----------------------------|-------------------|
| Box shape         | Truncated octahedron        | Orthorhombic               | truncated octahedral |
| Solvent buffer    | 10.0 Å                      | 10.0 Å                     | 12 Å  (-> fix)    |
| Water model       | TIP3P                       | TIP3P                      | TIP3P             |
| Non-bonded cutoff | 10.0 Å                      | 9.0 Å                      | 10.0 Å (-> fix apo) |
| Ensemble          | NPT                         | NPT                        | NPT               |
| Thermostat        | Langevin (ntt=3)            | Langevin (ntt=3)           | Langevin          |
| Barostat          | Berendsen (barostat=1)      | Monte Carlo (barostat=2)   | Monte Carlo (-> fix bound) |
| Temperature       | 300 K                       | 300 K                      | 300 K             |
| Timestep          | 2 fs (SHAKE)                | 2 fs (SHAKE)               | 2 fs, SHAKE       |
| Length            | 1 µs                        | 1 µs                       | 1 µs              |
| Cluster restraints| 12 Fe-S dist. (nmropt=1)    | 12 Fe-S dist. (nmropt=1)   | not mentioned (-> add) |

Note: `prod.in` / `disang.rest` provided here are for the bound system
(atom indices 16057-16064). The apo run used the same restraint scheme on its
own indices (11408-11411 / 11404-11407), with `cut=9.0` and `barostat=2`.

## Software

Gaussian 16 (B3LYP/6-31G*, LanL2DZ on Fe) · AmberTools/MCPB.py ·
Amber24 PMEMD.cuda · ff14SB · TIP3P
