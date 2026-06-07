# Trabajo 2 --- Optimización Aplicada (Primera Parte)
# Archivo .mod para la formulación Single Commodity Flow en el problema de Steiner relajado.
# Autores: Daniel Lugaresi Palomares, Iker Rodríguez Rodríguez

# Ver archivo original STSP_SCF para los comentarios. Solo cambiamos las variables
# discretas por continuas.

set CITIES ordered;
set REQ within CITIES;

param n := card {CITIES};
param nG := card {REQ};

set EDGES within {i in CITIES, j in CITIES: i < j};

set EFor := setof {(i,j) in EDGES} (i,j);
set EBack := setof {(i,j) in EDGES} (j,i);
set LINKS := EFor union EBack;

param COST_int {EDGES} >= 0;


param COST {(i,j) in LINKS} := if (i,j) in EDGES then COST_int[i,j] else COST_int[j,i];

var x {LINKS}>= 0;
var f {LINKS} >= 0;

minimize Total_Cost: sum{(i,j) in LINKS} COST[i,j] * x[i,j];

subject to VisitReq {i in REQ}: sum {(i,j) in LINKS} x[i,j] >= 1;

subject to FlowCons {i in CITIES}: sum {(i,j) in LINKS} x[i,j] = sum {(j,i) in LINKS} x[j,i];

subject to FlowReq {i in REQ diff {first(CITIES)}}:
    sum {(j,i) in LINKS} f[j,i] - sum {(i,j) in LINKS} f[i,j] = 1;

subject to FlowNonReq {i in CITIES diff REQ}:
    sum {(j,i) in LINKS} f[j,i] - sum {(i,j) in LINKS} f[i,j] = 0;

subj to FlowCap {(i,j) in LINKS}: f[i,j] <= (nG - 1) * x[i,j];