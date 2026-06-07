# Trabajo 2 --- Optimización Aplicada (Primera Parte):
# Archivo .mod para la formulación Single-Commodity del problema TSP.
# Autores: Daniel Lugaresi Palomares, Iker Rodríguez Rodríguez.

####################
# Datos del problema
####################
# - Nodos (CITIES)
# - Conjunto de nodos sin el primer nodo (CITIES1)
# - Número de nodos (n)
# - aristas (LINKS)
# - Costes (COST)
#
set CITIES ordered;
param n := card {CITIES};

# Construimos el conjunto de aristas
set LINKS := {i in CITIES, j in CITIES: ord(i) <> ord(j)};

# Conjunto de ciudades sin el nodo de partida
set CITIES1 ordered :=CITIES diff {first(CITIES)};

# Costes
param COST{LINKS} >= 0;
#
###########

###############
# variables
###############
# - Aristas que se activan (x)
# - Flujo que transcurre por la arista (i,j) (f)
var x{LINKS} binary;
var f{LINKS} >= 0;

##############
# Modelo 
##############

# Función objetivo
#####################

minimize Total_Cost: sum {(i,j) in LINKS} COST[i,j] * x[i,j];

# Restricciones
#####################

# Debemos salir de cada ciudad una vez, exactamente:
subj to Leave {i in CITIES}: 
   sum {(i,j) in LINKS} x[i,j] = 1;

# Debemos llegar a cada ciudad exactamente una vez:
subj to Reach {i in CITIES}: 
   sum {(i,j) in LINKS} x[j,i] = 1;

# Si estamos en la primera ciudad, entonces se inicializa el flujo a n-1:
subj to FlowNFB1:
	sum{(first(CITIES),j) in LINKS} f[first(CITIES),j] - sum{(j,first(CITIES)) in LINKS} f[j,first(CITIES)]=n-1; 

# En cada ciuad debemos dejar una unidad de flujo:
subj to FlowNFBrest {i in CITIES1}:
	sum{(i,j) in LINKS} f[i,j] - sum{(j,i) in LINKS} f[j,i]=-1;
	
# Solo podemos usar las aristas que se activan:
subj to SubtourNFB {(i,j) in LINKS}:
	f[i,j]<=(n-1)*x[i,j];
