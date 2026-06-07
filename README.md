# Análisis de distintas formulaciones de los problemas TSP y STSP
Analysis and computational comparison of different mathematical formulations for the TSP (Travelling Salesman Problem) and STSP (Steiner Travelling Salesman Problem).
## Overview
This project studies several mathematical formulations for the Traveling Salesman Problem (TSP) and the Steiner Traveling Salesman Problem (STSP). For the TSP, we analyze the DFJ, Single Commodity Flow (SCF), Multi Commodity Flow (MCF), and Time-Staged (TS) formulations. For the STSP, we study the Fleischmann's formulation, SCF and TS formulation. The comparison focuses on theoretical properties, model size, linear relaxation strength, and computational performance through numerical experiments implemented in AMPL.

Different formulations are implemented and tested using mathematical programming tools, allowing a detailed analysis of solution quality, computational efficiency, and scalability.
## Contents
- Introduction
- TSP: Definition and Formulations.
- STSP: Definition and Formulations.
- Computational Study
- Comparative Analysis of Results.
- Conclusions.
- References.
## Tools
- **AMPL**: Mathematical programming and implementation of TSP and STSP formulations.
- **Gurobi**: Solution of the resulting mixed-integer linear programs.
- **Python**: Visualization of network instances and optimal tours.
- **R**: Generation of random problem instances and computational experiments.
## Repository Structure

```text
.
├── AMPL/
│   ├── TSP/
│   └── STSP/
├── R/
│   ├── Generador_TSP.R
│   └── Generador_STSP.R
├── Python/
│   ├── Plots_TSP.py
│   ├── Plots_STSP.py
│   └── Plots_Ejemplos.py
├── Figures/
├── Report.pdf
└── README.md
```
## Team
This repository contains material from a group academic project developed collaboratively by:
- Daniel Lugaresi Palomares
- Iker Rodríguez Rodríguez
## Disclaimer
This repository is intended for educational and academic purposes. The work was carried out as part of a university project and is shared to showcase the methodology, implementation, and results obtained during the project.
