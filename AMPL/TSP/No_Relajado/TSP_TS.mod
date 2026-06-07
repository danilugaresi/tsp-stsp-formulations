# Trabajo 2 --- Optimización Aplicada (Primera Parte):
# Archivo .mod para la formulación Time Staged del problema TSP relajado.
# Autores: Daniel Lugaresi Palomares, Iker Rodríguez Rodríguez.

####################
# Datos del problema
####################
# - Nodos (CITIES)
# - Número de nodos (n)
# - aristas (LINKS)
# - Costes (COST)
#
set CITIES ordered;
param n := card {CITIES};

# Construimos el conjunto de aristas
set LINKS := {i in CITIES, j in CITIES: ord(i) <> ord(j)};

# Costes
param COST {LINKS};
#
###########

###############
# variables
###############
# - Arista que se activa en la etapa k: r_ij^k
var r {k in CITIES,(i,j) in LINKS}, binary;
#
###############

##############
# Modelo 
##############

# Función objetivo
#####################

minimize Total_Cost: sum{i in 2..n} COST[1,i]*r[1,1,i] + sum{k in 2..n-1,(i,j) in LINKS: i !=1 and j!=1} COST[i,j]*r[k,i,j] + 
					 sum{i in 2..n}COST[i,1]*r[n,i,1];

# Restricciones
#####################

# Debemos partir del nodo 1 y volver a él:
subject to start_1: sum{j in 2..n} r[1,1,j] = 1;
subject to end_1: sum{j in 2..n}  r[n,j,1] = 1;

# Tenemos que visitar cada nodo una vez:
subject to for_every_node {i in 1..n}: sum{k in 1..n,j in CITIES: j != i} r[k,j,i] = 1;

# De todo nodo que visitemos debemos salir:
subject to out_every_node {i in 2..n, k in 1..n-1}: sum{j in CITIES: j != i} r[k,j,i] - 
													sum{j in CITIES: j!= i} r[k+1,i,j] = 0;
