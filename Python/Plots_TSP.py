# Plot de los grafos y soluciones óptimas -- Problema TSP
# Librerías requeridas: networkx (grafos), matplotlib (herramientas gráficas)
# Ejecutar en terminal ' pip install networkx matplotlib '

# Librerías
import networkx as nw
import matplotlib.pyplot as plt
import math

# Pedimos al usuario el tipo de formulación
tipo = input("Introduce formulación ('d' DFJ, 'm' MCF, 's' SCF, 't' Time-Staged): ").lower()

if tipo == "d":
    archivo_sol = "TSP_DFJ_Out.txt"
    col_nodos = "#ff8c00"
elif tipo == "m":
    archivo_sol = "TSP_MCF_Out.txt"
    col_nodos = "#a6c8ff"
elif tipo == "s":
    archivo_sol = "TSP_SCF_Out.txt"
    col_nodos = "#7964d8aa"
elif tipo == "t":
    archivo_sol = "TSP_TS_Out.txt"
    col_nodos = "#d100d1"
else:
    raise ValueError("Código no válido. Usa 'd', 'm', 's' o 't'.")

# Objetos
G = nw.Graph()

# Lectura del grafo
with open("grafo.txt") as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        
        i, j, c = line.split()
        G.add_edge(int(i), int(j), weight=float(c))

# Lectura de la solución
sol_aristas = [] # Lista para las aristas solución
metricas = {} # Métricas de la solución (Lower Bound, Upper bound, gap relativo, ...)

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

# Nodos utilizados (en TSP serán todos, pero lo dejamos general)
nodos_usados = set()
for i, j in sol_aristas:
    nodos_usados.add(i)
    nodos_usados.add(j)

## La siguiente parte del código permite disponer los nodos en orden recorrido en una circunferencia

# Reconstruimos el tour
sucesor = {i: j for i, j in sol_aristas} # Diccionario: cada nodo i apunta al nodo siguiente j, i -> j

tour = [1]  # Nodo inicial
actual = 1 # Nodo actual

while True:
    siguiente = sucesor[actual] # Vamos del nodo actual al siguiente
    if siguiente == tour[0]: # Cuando volvemos al inicial (tour[0] = 1), rompemos el while
        tour.append(siguiente)
        break
    tour.append(siguiente) # Añadimos a la lista tour el siguiente nodo
    actual = siguiente # Convertimos en "actual" el nodo que antes era el "siguiente"

# Aristas ordenadas del tour
aristas_tour = [(tour[i], tour[i+1]) for i in range(len(tour)-1)]

## Disposición en forma de circunferencia

n = len(tour) - 1 # Número de nodos (el último repite el primero)
pos = {} # Para guardar las posiciones

for idx, nodo in enumerate(tour[:-1]): # Para cada índice y nodo asociado
    angulo = 2 * math.pi * idx / n + math.pi/2  # Asociamos un ángulo 2*pi*indice/n + pi/2 (esto asegura que el inicial (1) esté arriba siempre)
    pos[nodo] = (math.cos(angulo), math.sin(angulo)) # Y lo disponemos sobre la curva alpha(t) = (cos(t),sen(t))

# Etiquetas de coste
edge_labels = {}

for i, j in aristas_tour:
    if G.has_edge(i, j):
        edge_labels[(i, j)] = G[i][j]['weight']
    else:
        edge_labels[(i, j)] = G[j][i]['weight']

# Dibujo del grafo
plt.figure(figsize=(12,12))

# Nodos del tour
labels = {i: i for i in nodos_usados}
nw.draw_networkx_nodes(G, pos, nodelist=list(nodos_usados), node_color=col_nodos, node_size=220,
    alpha=1, edgecolors="black", linewidths=1.1)
nw.draw_networkx_labels(G, pos, labels=labels, font_size=9)

# Aristas solución

# Sombra
nw.draw_networkx_edges(G, pos, edgelist=aristas_tour, edge_color="black", width=2, alpha=0.5, arrows=True,
    arrowstyle="-|>", arrowsize=18, connectionstyle="arc3,rad=0")

# Aristas en azul
nw.draw_networkx_edges(G, pos, edgelist=aristas_tour, edge_color="#000000", width=2, arrows=True,
    arrowstyle="-|>", arrowsize=15, connectionstyle="arc3,rad=0")

# Etiquetas con los costes

for i, j in aristas_tour:
    
    # Accedemos a las etiquetas
    if G.has_edge(i, j):
        w = G[i][j]['weight']
    else:
        w = G[j][i]['weight']
    
    label = f"{w:.1f}"

    # Posiciones de los nodos
    x1, y1 = pos[i]
    x2, y2 = pos[j]

    # Idea: disponerlas sobre el punto medio de cada arista:

    # Punto medio
    xm, ym = (x1 + x2) / 2, (y1 + y2) / 2

    # Cada arista se puede ver como un vector, podemos calcular el ortogonal y normalizar:
    dx, dy = x2 - x1, y2 - y1
    norm = (dx**2 + dy**2)**0.5
    if norm == 0: # Por si ya sale normalizado, para no dividir por cero
        continue
    px, py = -dy / norm, dx / norm

    # Desplazamiento con respecto al vector normal
    offset = 0.08
    xm += px * offset
    ym += py * offset

    # Texto
    plt.text(xm, ym, label, fontsize=8, ha='center', va='center', bbox=dict(boxstyle="round,pad=0.2", fc="white", alpha=0.7))

# Leyenda
legend_text = f"Obj = {metricas['obj']}\nLB = {metricas['bestbound']}\nRelGap = {metricas['gap']}\nTime = {metricas['solve_time']:.2f}s"

plt.text(0.02, 0.98, legend_text, transform=plt.gca().transAxes, fontsize=10, verticalalignment='top', 
         bbox=dict(boxstyle='round', facecolor='white', alpha=0.8))

plt.axis("off")
plt.show()