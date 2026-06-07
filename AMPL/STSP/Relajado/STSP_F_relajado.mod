# Trabajo 2 --- Optimización Aplicada (Primera Parte)
# Archivo .mod para la formulación de Fleischmann en el problema de Steiner relajado
# Autores: Daniel Lugaresi Palomares, Iker Rodríguez Rodríguez

# Ver archivo original STSP_F para los comentarios. Solo cambiamos las variables
# binarias por reales.

set CITIES ordered;
set REQ within CITIES;

param n := card {CITIES};

set EDGES within {i in CITIES, j in CITIES: i < j};

param COST_int {EDGES} >= 0;

var x {EDGES}, >= 0; 

var m{i in CITIES}, >= 0;

set POWCARD := 0 .. (2**n - 1);

set POW{k in POWCARD} := {i in CITIES: (k div 2**(ord(i)-1)) mod 2 = 1};

minimize Total_Cost: sum{(i,j) in EDGES} COST_int[i,j] * x[i,j];

subj to Cut_Fleischmann {k in POWCARD: card(POW[k]) >= 1 and card(POW[k]) < n and
    card(POW[k] inter REQ) >= 1 and card(REQ diff POW[k]) >= 1}:
    sum {(i,j) in EDGES: (i in POW[k] and j not in POW[k]) or (j in POW[k] and i not in POW[k])} x[i,j] >= 2; 
 
subj to Even_Degree {i in CITIES}: sum {(u,v) in EDGES: u = i or v = i} x[u,v] = 2 * m[i];

