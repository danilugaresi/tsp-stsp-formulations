# Trabajo 2 --- Optimización Aplicada (Primera Parte)
# Archivo .mod para la formulación Single Commodity Flow en el problema de Steiner
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
# - Aristas que se activan (x)
# - Variables de flujo de i a j (f)
var x {LINKS} binary;
var f {LINKS} >= 0;
#
###############

##############
# Modelo 
##############

# Función objetivo
#####################

minimize Total_Cost: sum{(i,j) in LINKS} COST[i,j] * x[i,j];

### Observación: dado que cada arista dirigida (i,j) (i->j) se almacena en LINKS,
# Podemos modelar delta^+(i) = {Aristas que salen del nodo i} como: para cada i, {(i,j) in LINKS}, con j libre

# Restricciones
#####################

# Debemos visitar al menos una vez cada nodo requerido:
subject to VisitReq {i in REQ}: sum {(i,j) in LINKS} x[i,j] >= 1;

# Ley de la conservación de flujo en los nodos (conservación del grado del nodo):
subject to FlowCons {i in CITIES}: sum {(i,j) in LINKS} x[i,j] = sum {(j,i) in LINKS} x[j,i];

# Dejamos flujo en cada nodo requerido visitado:
subject to FlowReq {i in REQ diff {first(CITIES)}}:
    sum {(j,i) in LINKS} f[j,i] - sum {(i,j) in LINKS} f[i,j] = 1;

# No dejamos flujo en los nodos no requeridos que visitamos:
subject to FlowNonReq {i in CITIES diff REQ}:
    sum {(j,i) in LINKS} f[j,i] - sum {(i,j) in LINKS} f[i,j] = 0;

# Si el arco no se usa, la variable y el flujo asociados son cero, si no, puede llevar hasta card(N_G) - 1 unidades de flujo:
subj to FlowCap {(i,j) in LINKS}: f[i,j] <= (nG - 1) * x[i,j];