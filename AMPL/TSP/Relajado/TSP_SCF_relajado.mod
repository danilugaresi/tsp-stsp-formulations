# Trabajo 2 --- Optimización Aplicada (Primera Parte):
# Archivo .mod para la formulación Single-Commodity del problema TSP rellajado.
# Autores: Daniel Lugaresi Palomares, Iker Rodríguez Rodríguez.

# Ver archivo original TSP_SCF para los comentarios. Solo cambiamos las variables
# binarias por reales.

set CITIES ordered;
param n := card {CITIES};

set LINKS := {i in CITIES, j in CITIES: ord(i) <> ord(j)};

set CITIES1 ordered :=CITIES diff {first(CITIES)};

param COST{LINKS} >= 0;

var x{LINKS} >= 0;
var f{LINKS} >= 0;  

# Función objetivo
minimize Total_Cost: sum {(i,j) in LINKS} COST[i,j] * x[i,j];


subj to Leave {i in CITIES}: 
   sum {(i,j) in LINKS} x[i,j] = 1;

# debemos llegar a cada ciudad exactamente una vez
subj to Reach {i in CITIES}: 
   sum {(i,j) in LINKS} x[j,i] = 1;

# si estamos en la primera ciudad entonces se inicializa el flujo a n-1
subj to FlowNFB1:
	sum{(first(CITIES),j) in LINKS} f[first(CITIES),j] - sum{(j,first(CITIES)) in LINKS} f[j,first(CITIES)]=n-1; 

# En cada ciuad debemos dejar una unidad de flujo
subj to FlowNFBrest {i in CITIES1}:
	sum{(i,j) in LINKS} f[i,j] - sum{(j,i) in LINKS} f[j,i]=-1;
	
# sólo podemos usar las aristas que se activan.
subj to SubtourNFB {(i,j) in LINKS}:
	f[i,j]<=(n-1)*x[i,j];
