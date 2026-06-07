#### Generador de instancias para el problema TSP
# Trabajo 2 --- Optimización Aplicada (Primera parte)
# Autores: Daniel Lugaresi Palomares, Iker Rodríguez Rodríguez
# Generador basado en el del archivo "TSP_Instance.r", utilizado
# en clase

setwd("C:/ESCRITORIO/CARRERA/Programas/AMPLAct/AMPLRunVSCode/OptimizacionAplicada/Trabajo2/TSP")

options("scipen"=1000)

# Número de ciudades
n <- 10

# Nombre del archivo
filename <- paste("Instancia_TSP", ".dat", sep="")

# CIUDADES
CITIES <- 1:n

# Parejas de nodos (i,j)
pairs <- expand.grid(i = CITIES, j = CITIES)
pairs <- pairs[pairs$i != pairs$j, ] # Sin lazos (quitamos (i,i))

# Generamos los costes aleatoriamente
pairs$cost <- round(runif(nrow(pairs), 0, 100), 3)

# Contenido del archivo .dat
lines <- c()

# CIUDADES
lines <- c(lines,paste("set CITIES :=", paste(CITIES, collapse=" "), ";"),"")

# COSTES
lines <- c(lines, "param COST :=")

for(k in 1:nrow(pairs)) {
  lines <- c(lines, paste0("[", pairs$i[k], ",", pairs$j[k], "] ", pairs$cost[k]))
}

lines <- c(lines, ";")

# Escritura del archivo
writeLines(lines, filename)
