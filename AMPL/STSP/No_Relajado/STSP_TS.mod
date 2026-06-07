# Trabajo 2 --- Optimización Aplicada (Primera Parte)
# Archivo .mod para la formulación Time-Staged en el problema de Steiner.
# Autores: Daniel Lugaresi Palomares, Iker Rodríguez Rodríguez

####################
# Datos del problema
####################
# - Nodos (CITIES)
# - Nodos requeridos (REQ)
# - Aristas (EDGES)
# - Aristas orientadas (LINKS)
# - Costes de cada arista no orientada (COST_int)
# - Costes repetidos para cada orientación de la arista (COST)
#
set CITIES ordered;
set REQ within CITIES;

param n := card {CITIES};
param nG := card {REQ};
param Dg := 2 * (n - 1); # Cota superior de los pasos necesarios

# Aristas del grafo simple, no necesariamente completo. No se repiten en el .dat
set EDGES within {i in CITIES, j in CITIES: i < j};

# Escogemos todos los pares posibles de nodos (grafo dirigido)
set EFor := setof {(i,j) in EDGES} (i,j);
set EBack := setof {(i,j) in EDGES} (j,i); # Subconjunto con aristas al revés
set LINKS := EFor union EBack; # Unión de las aristas en ambos sentidos

param COST_int {EDGES} >= 0;

# Repetimos los costes, son los mismos para (i,j) y para (j,i)
param COST {(i,j) in LINKS} := if (i,j) in EDGES then COST_int[i,j] else COST_int[j,i];
# Si (i,j) es un nodo introducido en el .dat, le asigna su valor, si no, le asigna
# (j,i), que necesariamente es un nodo introducido en el .dat
#
############

###############
# variables
###############
# - Arista que se activa en la etapa k del tour, r_ij^k
var r {k in 1..Dg,(i,j) in LINKS}, binary;

##############
# Modelo 
##############

# Función objetivo
#####################

minimize Total_Cost: sum{k in 1..Dg} sum{(i,j) in LINKS} r[k,i,j]*COST[i,j];

# Restricciones
#####################

# Debemos salir del nodo inicial 1:
subject to Origin_init: sum{(i,j) in LINKS: i = 1} r[1,1,j] = 1;

# No podemos empezar por ningún otro sitio:
subject to No_other_init {(i,j) in LINKS : i != 1}: r[1,i,j] = 0;

# Debemos empezar y terminar en el mismo sitio:
subject to Same_init_fin: 
	sum{k in 1..Dg} sum{(i,j) in LINKS: i = 1} r[k,i,j] = sum{k in 1..Dg} sum{(i,j) in LINKS: j = 1} r[k,i,j];

# Debemos pasar por cada nodo requerido por lo menos una vez:
subject to for_all_cities {i in REQ}: sum{k in 1..Dg} sum{(i,j) in LINKS} r[k,i,j] >= 1;

# Debemos salir del nodo al que llegamos::
subject to conservation {i in CITIES, k in 1..Dg-1}: 
	sum{(j,i) in LINKS} r[k,j,i] >= sum{(i,j) in LINKS} r[k+1,i,j];