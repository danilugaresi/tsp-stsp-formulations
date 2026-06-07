# Trabajo 2 --- Optimización Aplicada (Primera Parte):
# Archivo .mod para la formulación Time Staged del problema TSP relajado.
# Autores: Daniel Lugaresi Palomares, Iker Rodríguez Rodríguez.

# Ver archivo original TSP_TS para los comentarios. Solo cambiamos las variables
# binarias por reales.

set CITIES ordered;
param n := card {CITIES};

set LINKS := {i in CITIES, j in CITIES: ord(i) <> ord(j)};

param COST {LINKS};
 
var r {k in CITIES,(i,j) in LINKS}>= 0;

minimize Total_Cost: sum{i in 2..n} COST[1,i]*r[1,1,i] + 
					sum{k in 2..n-1,(i,j) in LINKS: i !=1 and j!=1} COST[i,j]*r[k,i,j] + 
					sum{i in 2..n}COST[i,1]*r[n,i,1];

subject to start_1: sum{j in 2..n} r[1,1,j] = 1;
subject to end_1: sum{j in 2..n}  r[n,j,1] = 1;

subject to for_every_node {i in 1..n}: sum{k in 1..n,j in CITIES: j != i} r[k,j,i] = 1;

subject to out_every_node {i in 2..n, k in 1..n-1}: sum{j in CITIES: j != i} r[k,j,i] - 
													sum{j in CITIES: j!= i} r[k+1,i,j] = 0;
