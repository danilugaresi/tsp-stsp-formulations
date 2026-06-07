# Trabajo 2 --- Optimización Aplicada (Primera Parte):
# Archivo .mod para la formulación Multicommodity Flow del problema TSP.
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
# - Aristas que se activan (x)
# - Variables de flujo de i a j con destino el nodo k (f)
var x {(i,j) in LINKS}, binary;
var f {k in CITIES,(i,j) in LINKS} >= 0;
#
#######

##############
# Modelo 
##############

# Función objetivo
#####################
minimize Total_Cost: sum{(i,j) in LINKS} COST[i,j]*x[i,j];

# Restricciones
#####################

# Debemos salir de cada ciudad exactamente uan vez:
subject to out_from_cities {i in CITIES}: sum{(i,j) in LINKS} x[i,j] = 1;

# Debemos entrar a cada ciudad exactamente una vez:
subject to intO_cities {i in CITIES}: sum{(j,i) in LINKS} x[j,i] = 1;

# No podemos mandar flujo a ninguna arista que no pertenezca a la ruta óptima:
subject to flow {k in 2..n, (i,j) in LINKS}: f[k,i,j] <= x[i,j];

# El flujo que va al nodo k debe salir del nodo 1:
subject to out_from_1 {k in 2..n}: sum{i in 2..n} f[k,1,i] = 1;

# El flujo con destino k debe llegar al nodo k:
subject to arrive_to_k {k in 2..n}: sum{i in 1..n: i != k} f[k,i,k] = 1;

# Restricciones de conservación de flujo:
subject to conservation_flow {k in 2..n,j in 2..n: j != k}: sum{i in 1..n: i != j} f[k,i,j] - sum{i in 2..n: i != j} f[k,j,i] = 0;