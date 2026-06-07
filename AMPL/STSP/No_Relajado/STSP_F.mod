# Trabajo 2 --- Optimización Aplicada (Primera Parte)
# Archivo .mod para la formulación de Fleischmann en el problema de Steiner
# Autores: Daniel Lugaresi Palomares, Iker Rodríguez Rodríguez

####################
# Datos del problema
####################
# - Nodos (CITIES)
# - Nodos requeridos (REQ)
# - Aristas (EDGES)
# - Costes de cada arista no orientada (COST_int)
# - Todos los posibles subconjuntos de nodos (POW)
set CITIES ordered;
set REQ within CITIES;

param n := card {CITIES};

set EDGES within {i in CITIES, j in CITIES: i < j};

# Subconjuntos posibles
set POWCARD := 0 .. (2**n - 1);

set POW{k in POWCARD} := {i in CITIES: (k div 2**(ord(i)-1)) mod 2 = 1};

# Costes asociados a cada arista simple
param COST_int {EDGES} >= 0;
#
############

###############
# variables
###############
# - Aristas que se activan x_ij. No contamos las dos orientaciones i -> j, j -> i, solo la propia arista
# - Variables auxiliares para la restricción de paridad
var x {EDGES} integer >= 0; 

var m{i in CITIES} integer >= 0;
#
###############

# Función objetivo
#####################

minimize Total_Cost: sum{(i,j) in EDGES} COST_int[i,j] * x[i,j];

# Restricciones
#####################

# Eliminación de posibles subtours
# Recordatorio de operadores: inter -> Intersección de conjuntos, diff -> Diferencia de conjuntos (resta)
subj to Cut_Fleischmann {k in POWCARD: card(POW[k]) >= 1 and card(POW[k]) < n and
    card(POW[k] inter REQ) >= 1 and card(REQ diff POW[k]) >= 1}: # Recorremos los i en S, y los j que no están en S
    sum {(i,j) in EDGES: (i in POW[k] and j not in POW[k]) or (j in POW[k] and i not in POW[k])} x[i,j] >= 2; 
 
# Circuito euleriano: conservación del grado en cada nodo
subj to Even_Degree {i in CITIES}: sum {(u,v) in EDGES: u = i or v = i} x[u,v] = 2 * m[i];