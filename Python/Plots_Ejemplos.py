# Plot de los grafos y soluciones óptimas
# Librerías requeridas: networkx (grafos), matplotlib (herramientas gráficas)
# Ejecutar en terminal ' pip install networkx matplotlib '
# Se pueden representar con este script grafos de tamaño pequeño, entre 2 y 20 nodos

# Librerías
import networkx as nw
import matplotlib.pyplot as plt
import random
import itertools
import math

# Pedimos el tipo de ejemplo
tipo = input("Introduce tipo ('g' grafo general, 'c' grafo completo): ").lower()

# =========================
# GRAFO GENERAL (sparse)
# =========================
if tipo == "g":

    G = nw.Graph()
    n = 10

    # Añadimos nodos
    G.add_nodes_from(range(1, n+1))

    # Añadimos aristas aleatorias
    for i, j in itertools.combinations(G.nodes(), 2):
        if random.random() < 0.25:  # densidad baja
            G.add_edge(i, j, weight=round(random.uniform(1,10),1))

    # Asegurar conectividad
    if not nw.is_connected(G):
        nodos = list(G.nodes())
        for i in range(n-1):
            G.add_edge(nodos[i], nodos[i+1], weight=round(random.uniform(1,10),1))

    # Nodos requeridos (ejemplo)
    requeridos = set(random.sample(list(G.nodes()), 4))

    pos = nw.spring_layout(G, seed=3)

    plt.figure(figsize=(7,5))

    # Fondo
    nw.draw(G, pos, node_color="#d9d9d9", with_labels=True, width=0.5)

    # Nodos requeridos
    nw.draw_networkx_nodes(
        G, pos,
        nodelist=list(requeridos),
        node_color="#ff9999"
    )

    plt.title("Grafo general (STSP)")

# =========================
# GRAFO COMPLETO (TSP)
# =========================
elif tipo == "c":

    G = nw.Graph()
    n = 5

    # Posiciones en círculo
    pos = {}
    for i in range(n):
        ang = 2 * math.pi * i / n + math.pi/2
        pos[i+1] = (math.cos(ang), math.sin(ang))

    G.add_nodes_from(range(1, n+1))

    # Grafo completo con distancias euclídeas
    for i, j in itertools.combinations(G.nodes(), 2):
        x1, y1 = pos[i]
        x2, y2 = pos[j]
        w = ((x1-x2)**2 + (y1-y2)**2)**0.5
        G.add_edge(i, j, weight=round(w,2))

    plt.figure(figsize=(6,6))

    nw.draw(
        G, pos,
        node_color="#a6c8ff",
        with_labels=True,
        width=1
    )

    plt.title("Grafo completo (TSP)")

else:
    raise ValueError("Código no válido. Usa 'g' o 'c'.")

plt.show()