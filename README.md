# Análisis de distintas formulaciones de los problemas TSP y STSP
Análisis y comparación computacional de distintas formulaciones matemáticas para el problema del viajante (TSP, Travelling Salesman Problem) y el problema del viajante de Steiner (STSP, Steiner Travelling Salesman Problem). Proyecto desarrollado colaborativamente por:

- Daniel Lugaresi Palomares
- Iker Rodríguez Rodríguez
## Descripción
Para el TSP se analizan las formulaciones DFJ, Single Commodity Flow (SCF), Multi Commodity Flow (MCF) y Time-Staged (TS). Para el STSP se estudia la formulación de Fleischmann, así como las formulaciones SCF y TS.

La comparación se centra en las propiedades teóricas de cada modelo, su tamaño, la calidad de sus relajaciones lineales y su rendimiento computacional mediante un análisis computacional realizado a partir de la implementación en AMPL de cada formulación, generando instancias aleatorias con R.

Las distintas formulaciones se implementan y evalúan utilizando herramientas de programación matemática, lo que permite realizar un análisis detallado de la calidad de las soluciones obtenidas, la eficiencia computacional y la escalabilidad de cada enfoque.
## Contenidos
* Introducción
* TSP: definición y formulaciones
* STSP: definición y formulaciones
* Estudio computacional
* Análisis comparativo de resultados
* Conclusiones
* Referencias
## Herramientas
* **AMPL**: programación matemática e implementación de las formulaciones del TSP y STSP.
* **Gurobi**: resolución de los problemas de programación lineal entera mixta resultantes.
* **Python**: visualización de instancias de red y recorridos óptimos.
* **R**: generación de instancias aleatorias y realización de experimentos computacionales.
## Estructura del repositorio
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

