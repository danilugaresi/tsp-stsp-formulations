#### Generador de instancias para el problema STSP
# Trabajo 2 --- Optimización Aplicada (Primera parte)
# Autores: Daniel Lugaresi Palomares, Iker Rodríguez Rodríguez

setwd("C:/ESCRITORIO/CARRERA/Programas/AMPLAct/AMPLRunVSCode/OptimizacionAplicada/Trabajo2/STSP")

# La siguiente función permite generar un problema arbitrario de cualquier tamaño
# del tipo Steiner TSP. Argumentos:
# n_nodes -> Número de nodos del grafo
# prob_edge -> Proporción de aristas entre nodos (una por cada par)
# req_ratio -> Proporción de nodos requeridos
# Generación de datos: modelo aleatorio de Erdös-Renyi

generate_STSP_dat <- function(n_nodes, prob_edge, req_ratio, filename = "instancia.dat") {
  
  # Conjunto de ciudades (nodos)
  CITIES <- 1:n_nodes

  # Conjunto de nodos requeridos
  n_req <- ceiling(req_ratio * n_nodes)
  REQ <- sort(sample(CITIES[2:n_nodes], n_req)) # Elegimos aleatoriamente los nodos requeridos,
  # necesariamente el 1 siempre tiene que estar, porque es de donde partimos,
  # si no, el problema no es factible
  REQ <- c(1,REQ)
  
  # Aristas
  EDGES <- matrix(ncol = 2, nrow = 0) # Se guardan como columna1 = i, columna2 = j
  
  # Erdös-Renyi -> Consideramos cada par de aristas (i,j), i < j
  for (i in 1:(n_nodes-1)) {
    for (j in (i+1):n_nodes) {
      # Simulamos una uniforme en (0,1), y añadimos la arista si sale < prob_edge
      if (runif(1) < prob_edge) {
        EDGES <- rbind(EDGES, c(i,j))
      }
    }
  }
  
  ### Paso extra: si el grafo no es conexo, puede resultar no factible el problema,
  # así que vamos a añadir las aristas 1 -> 2, 2 -> 3, ... n-1 -> n, para
  # asegurarnos de que el grafo sea conexo
  
   chain <- cbind(1:(n_nodes-1), 2:n_nodes)
   EDGES <- rbind(EDGES, chain)
  
  # Al añadir esta cadena, podemos estar metiendo duplicados en las generaciones Erdös-Renyi, 
  # así que los quitamos
  
   EDGES <- unique(EDGES)
   
  # Notemos que la solución obvia 1 -> 2 -> ... -> N -> N-1 -> ... -> 1 
  # no es necesariamente la óptima
  
  # COSTES
  COSTS <- sample(3:12, nrow(EDGES), replace = TRUE)
 
  # Escritura del archivo
  con <- file(filename, "w")
  
  # CIUDADES
  writeLines("set CITIES :=", con)
  writeLines(paste(CITIES, collapse = " "), con)
  writeLines(";\n", con)
  
  # NODOS REQUERIDOS
  writeLines("set REQ :=", con)
  writeLines(paste(REQ, collapse = " "), con)
  writeLines(";\n", con)
  
  # ARISTAS
  writeLines("set EDGES :=", con)
  for (k in 1:nrow(EDGES)) {
    writeLines(paste(EDGES[k,1], EDGES[k,2]), con)
  }
  writeLines(";\n", con)
  
  # COSTES
  writeLines("param COST_int :=", con)
  for (k in 1:nrow(EDGES)) {
    writeLines(paste(EDGES[k,1], EDGES[k,2], COSTS[k]), con)
  }
  writeLines(";\n", con)
  
  close(con)
  
  cat("Archivo generado:", filename, "\n")
}

# Usos de la función en el trabajo. Instancias utilizadas para probar
# el rendimiento de los solvers

# Instancia 1 -> Pequeña

set.seed(123)
generate_STSP_dat(18,0.2,0.4)

# Instancia 2 -> Mediana

set.seed(1)
generate_STSP_dat(21,0.2,0.2)

# Instancia 3 -> Grande

set.seed(1234)
generate_STSP_dat(50,0.01,0.05)

# Instancia 4 -> Muy Grande

set.seed(123)
generate_STSP_dat(150,0.005,0.01)

# Instancia 5 -> Enorme

set.seed(123)
generate_STSP_dat(800,0.005,0.01)
