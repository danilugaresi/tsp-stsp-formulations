# Plot de los grafos y soluciones óptimas -- Problema STSP
# Librerías requeridas: networkx (grafos), matplotlib (herramientas gráficas)
# Ejecutar en terminal ' pip install networkx matplotlib '
# Se pueden representar con este script grafos sparse de tamaño pequeño-mediano (hasta ~200 nodos para que se vea bien)

# Librerías
import networkx as nw
import matplotlib.pyplot as plt
import matplotlib.lines as mlines

# Pedimos al usuario el tipo de formulación
tipo = input("Introduce formulación ('s' Simple Commodity Flow, 't' Time-Staged, 'f' Fleischmann): ").lower()

if tipo == "s":
    archivo_sol = "STSP_SCF_out.txt"
    color_aristas = "#4a90e2"
elif tipo == "t":
    archivo_sol = "STSP_TS_out.txt"
    color_aristas = "#d100d1"
elif tipo == "f":
    archivo_sol = "STSP_F_out.txt"
    color_aristas = "#ff8c00"
else:
    raise ValueError("Código no válido. Usa 's', 't' o 'f'.")

# Objetos
G = nw.Graph()
requeridos = set() # Preparamos un conjunto para los nodos requeridos

# Lectura de los archivos de texto
with open("grafo.txt") as f:
    mode = None
    for line in f: # Iteramos en las líneas del texto
    # Reconocemos parte del grafo y parte de nodos requeridos
        line = line.strip()
        if line == "# GRAFO":
            mode = "edges"
            continue
        if line == "# REQUERIDOS":
            mode = "req"
            continue
    # Añadimos aristas al objeto G, y los nodos requeridos al conjunto "requeridos"
        if mode == "edges":
            i,j,c = line.split() # De los 3 valores por línea, los 2 primeros son los vértices de la arista y el último es el peso
            G.add_edge(int(i),int(j),weight=float(c))
        if mode == "req":
            requeridos.add(int(line)) # Nodos requeridos

# Lectura de la solución de Gurobi
sol_aristas = [] # Lista para las aristas solución
metricas = {} # Métricas de la solución (Lower Bound, Upper bound, gap relativo, ...)
pesos = set() # Conjunto reservado para los costes

if tipo == "s" or tipo == "t":
    with open(archivo_sol) as f:
        mode = None
        for line in f:
            line = line.strip()
            if line == "# SOLUCION":
                mode = "sol"
                continue
            if line == "# METRICAS":
                mode = "met"
                continue

            if mode == "sol":
                i,j = line.split()
                sol_aristas.append((int(i),int(j)))
            if mode == "met":
                k,v = line.split()
                metricas[k] = float(v)
else:
    with open(archivo_sol) as f:
        mode = None
        for line in f:
            line = line.strip()
            if line == "# SOLUCION":
                mode = "sol"
                continue
            if line == "# METRICAS":
                mode = "met"
                continue

            if mode == "sol":
                k,i,j = line.split()
                pesos.add(int(k))
                sol_aristas.append((int(k),int(i),int(j)))
            if mode == "met":
                k,v = line.split()
                metricas[k] = float(v)

# Nodos utilizados
nodos_usados = set()
if tipo == "s" or tipo == "t":
    for i, j in sol_aristas:
        nodos_usados.add(i)
        nodos_usados.add(j)
else:
    for k, i, j in sol_aristas:
        nodos_usados.add(i)
        nodos_usados.add(j)

# Separación de aristas según peso (en la formulación de Fleischmann, las variables indican si pasamos 2 veces o 1 por cada arista)
if tipo == "f":
    aristas_rojas = [(i,j) for k,i,j in sol_aristas if k == 2]
    aristas_naranja = [(i,j) for k,i,j in sol_aristas if k == 1]

# Parámetro del tipo de grafo, según la formulación (solo cambia para Fleischmann)
usar_flechas = tipo != "f"
estilo_flecha = '-|>' if usar_flechas else '-'
conexion = 'arc3,rad=0.15' if usar_flechas else 'arc3,rad=0'

# Dibujo del grafo
# Semillas usadas:
# STSP-SCF -> Instancia 1: 6; Instancia 2: 1; Instancia 3: 1; Instancia 4: 20;
# STSP-TS -> Instancia 1: 6; Instancia 2: 1; Instancia 3: 1; Instancia 4: 20;
# STSP-F -> Instancia 1: 6; Instancia 2: 1; Instancia 3: NA; Instancia 4: NA;
pos = nw.spring_layout(G, k=0.85, iterations=400, seed = 6) # spring_layout aplica una optimización para tratar de dibujar el grafo lo más
# plano posible (que no se crucen aristas), k es la distancia entre nodos e iterations es las iteraciones que le permitimos hacer al algoritmo
plt.figure(figsize=(12,12))

# Ponemos el grafo real de fondo para que se vea el contraste
nw.draw_networkx_nodes(G, pos, node_color="#d9d9d9", node_size=200, alpha=0.5)
nw.draw_networkx_edges(G, pos, width=0.1, alpha=0.4)

## Nodos

# Nodos usados con alpha = 1 (transparencia)
labels_destacados = {i: i for i in nodos_usados}
nw.draw_networkx_nodes(G, pos, nodelist=list(nodos_usados), node_color="#bbbbbb", node_size=200, alpha=1, edgecolors= "black", linewidths=1.15)
nw.draw_networkx_labels(G, pos, labels=labels_destacados, font_size=9, font_color="black")

# Nodos requeridos
nw.draw_networkx_nodes(G, pos, nodelist = [i for i in requeridos if i != 1], node_color="#ff9999", node_size = 200, edgecolors= "black", linewidths=1.15)

# Nodo origen
nw.draw_networkx_nodes(G, pos, nodelist=[1], node_color="#4ec259", node_size=200,
    edgecolors="black", linewidths=1.15)

## Aristas

if usar_flechas:
    # Sombra
    nw.draw_networkx_edges(G, pos, edgelist=sol_aristas, edge_color="black", width=1, alpha=0.6, arrows=True,
        arrowstyle=estilo_flecha, arrowsize=18, connectionstyle=conexion)
    # Arista
    nw.draw_networkx_edges(G, pos, edgelist=sol_aristas, edge_color=color_aristas, width=1,
        arrows=True, arrowstyle=estilo_flecha, arrowsize=15, connectionstyle=conexion)
else:
    # Aristas usadas 2 veces
    nw.draw_networkx_edges(G, pos, edgelist=aristas_rojas, edge_color="red", width=2,
    arrows=usar_flechas, arrowstyle=estilo_flecha, connectionstyle = conexion)
    # Aristas usadas 1 vez
    nw.draw_networkx_edges(G, pos, edgelist=aristas_naranja, edge_color="orange", width=2,
    arrows=usar_flechas, arrowstyle=estilo_flecha, connectionstyle = conexion)

# Leyenda
legend_text = f"Obj = {metricas['obj']}\nLB = {metricas['bestbound']}\nRelGap = {metricas['gap']}\nTime = {metricas['solve_time']:.2f}s"

plt.text(0.02, 0.98, legend_text, transform=plt.gca().transAxes, fontsize=10,
    verticalalignment='top',bbox=dict(boxstyle='round', facecolor='white', alpha=0.8))

plt.show()