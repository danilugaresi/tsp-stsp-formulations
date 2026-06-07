# Trabajo 2 --- Optimización Aplicada (Primera Parte)
# Archivo .mod para la formulación Time-Staged en el problema de Steiner relajado.
# Autores: Daniel Lugaresi Palomares, Iker Rodríguez Rodríguez

# Ver archivo original STSP_F para los comentarios. Solo cambiamos las variables
# binarias por reales.

set CITIES ordered;
set REQ within CITIES;

param n := card {CITIES};
param nG := card {REQ};
param Dg := 2 * (n - 1);

set EDGES within {i in CITIES, j in CITIES: i < j};

set EFor := setof {(i,j) in EDGES} (i,j);
set EBack := setof {(i,j) in EDGES} (j,i);
set LINKS := EFor union EBack;

param COST_int {EDGES} >= 0;

param COST {(i,j) in LINKS} := if (i,j) in EDGES then COST_int[i,j] else COST_int[j,i];

var r {k in 1..Dg,(i,j) in LINKS} >=0;

minimize Total_Cost: sum{k in 1..Dg} sum{(i,j) in LINKS} r[k,i,j]*COST[i,j];

subject to Origin_init: sum{(i,j) in LINKS: i = 1} r[1,1,j] = 1;

subject to No_other_init {(i,j) in LINKS : i != 1}: r[1,i,j] = 0;

subject to Same_init_fin: 
	sum{k in 1..Dg} sum{(i,j) in LINKS: i = 1} r[k,i,j] = sum{k in 1..Dg} sum{(i,j) in LINKS: j = 1} r[k,i,j];

subject to for_all_cities {i in REQ}: sum{k in 1..Dg} sum{(i,j) in LINKS} r[k,i,j] >= 1;

subject to conservation {i in CITIES, k in 1..Dg-1}: 
	sum{(j,i) in LINKS} r[k,j,i] >= sum{(i,j) in LINKS} r[k+1,i,j];