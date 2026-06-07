# Trabajo 2 --- Optimización Aplicada (Primera Parte):
# Archivo .mod para la formulación Multicommodity Flow del problema TSP relajado.
# Autores: Daniel Lugaresi Palomares, Iker Rodríguez Rodríguez.

# Ver archivo original TSP_MCF para los comentarios. Solo cambiamos las variables
# binarias por reales.

set CITIES ordered;

param n := card {CITIES};

set LINKS := {i in CITIES, j in CITIES: ord(i) <> ord(j)};

param COST {LINKS};

var x {(i,j) in LINKS} >= 0;
var f {k in CITIES,(i,j) in LINKS} >= 0;

minimize Total_Cost: sum{(i,j) in LINKS} COST[i,j]*x[i,j];

subject to out_from_cities {i in CITIES}: sum{(i,j) in LINKS} x[i,j] = 1;

subject to intO_cities {i in CITIES}: sum{(j,i) in LINKS} x[j,i] = 1;

subject to flow {k in 2..n, (i,j) in LINKS}: f[k,i,j] <= x[i,j];

subject to out_from_1 {k in 2..n}: sum{i in 2..n} f[k,1,i] = 1;

subject to arrive_to_k {k in 2..n}: sum{i in 1..n: i != k} f[k,i,k] = 1;

subject to conservation_flow {k in 2..n,j in 2..n: j != k}: sum{i in 1..n: i != j} f[k,i,j] - sum{i in 2..n: i != j} f[k,j,i] = 0;




