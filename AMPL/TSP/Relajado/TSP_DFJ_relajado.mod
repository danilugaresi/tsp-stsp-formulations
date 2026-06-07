# Trabajo 2 --- Optimización Aplicada (Primera Parte):
# Archivo .mod para la formulación Dantzig-Fulkerson-Johnson del problema TSP relajado.
# Autores: Daniel Lugaresi Palomares, Iker Rodríguez Rodríguez.

# Ver archivo original TSP_DFJ para los comentarios. Solo cambiamos las variables
# binarias por reales.

set CITIES ordered;
param n := card {CITIES};

set POWCARD := 0 .. (2**n - 1);
set POW{k in POWCARD} := {i in CITIES: (k div 2**(ord(i)-1)) mod 2 = 1};

set LINKS := {i in CITIES, j in CITIES: ord(i) <> ord(j)};

param COST{LINKS} >= 0;

var x{LINKS} >= 0; 

minimize Total_Cost: sum {(i,j) in LINKS} COST[i,j] * x[i,j];

subj to Leave {i in CITIES}: 
   sum {(i,j) in LINKS} x[i,j] = 1;

subj to Reach {i in CITIES}: 
   sum {(j,i) in LINKS} x[j,i] = 1;

subj to SubtourDFJ {k in POWCARD: card(POW[k])>1 and card(POW[k])<n}: 
   sum{i in POW[k], j in POW[k]: (i,j) in LINKS} x[i,j] <= card(POW[k])-1;