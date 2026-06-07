# Trabajo 2 --- Optimización Aplicada (Primera Parte):
# Archivo .mod para la formulación Dantzig-Fulkerson-Johnson del problema TSP.
# Autores: Daniel Lugaresi Palomares, Iker Rodríguez Rodríguez.


####################
# Datos del problema
####################
# - Nodos (CITIES)
# - Número de nodos (n)
# - Todos los posibles subconjuntos de nodos (POW)
# - aristas (LINKS)
# - Costes (COST)
#
set CITIES ordered;
param n := card {CITIES};

# Construimos todos los posibles subconuntos de nodos:
set POWCARD := 0 .. (2**n - 1);
set POW{k in POWCARD} := {i in CITIES: (k div 2**(ord(i)-1)) mod 2 = 1};

# construimos el conjunto de aristas.
set LINKS := {i in CITIES, j in CITIES: ord(i) <> ord(j)};

# Costes
param COST{LINKS} >= 0;
#
###########

###############
# variables
###############
# - Aristas que se activan
#
var x{LINKS} binary; 
#
#######

##############
# Modelo 
##############

# Función objetivo
#####################
minimize Total_Cost: sum {(i,j) in LINKS} COST[i,j] * x[i,j];

# Restricciones
#####################

# Debemos salir de cada ciudad exactamente uan vez
subj to Leave {i in CITIES}: sum {(i,j) in LINKS} x[i,j] = 1;

# Debemos entrar a cada ciudad exactamente una vez
subj to Reach {i in CITIES}: sum {(j,i) in LINKS} x[j,i] = 1;

# Restricción para la eliminación de subtours: de formarse dos subtours exigimos que exista una arista que los una
subj to SubtourDFJ {k in POWCARD: card(POW[k])>1 and card(POW[k])<n}: 
   sum{i in POW[k], j in POW[k]: (i,j) in LINKS} x[i,j] <= card(POW[k])-1;