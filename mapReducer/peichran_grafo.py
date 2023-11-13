import networkx as nx

def map_phase(graph):
    """ Map phase: asigna contribuciones de PageRank a los nodos vecinos. """
    contributions = []
    for node in graph:
        neighbors = list(graph[node])
        rank = graph.nodes[node]['rank']
        share = rank / len(neighbors)
        for neighbor in neighbors:
            contributions.append((neighbor, share))
    return contributions

def reduce_phase(contributions, damping_factor=0.85, num_nodes=1):
    """ Reduce phase: calcula el nuevo PageRank de cada nodo. """
    new_ranks = {}
    for node, contribution in contributions:
        if node not in new_ranks:
            new_ranks[node] = (1 - damping_factor) / num_nodes
        new_ranks[node] += damping_factor * contribution
    return new_ranks


file_path = 'index.txt'

def build_graph_from_index(file_path):
    file_relations = {}
    word_to_files = {}

    # Leer el archivo 'index.txt'
    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            if '\t' in line:  # Verificar si la línea contiene una tabulación
                word, occurrences = line.split('\t')
                occurrences = occurrences.strip(';').split(';')
                word_to_files[word] = []

                for occ in occurrences:
                    # Verificar si la ocurrencia sigue el formato esperado
                    if ':' in occ:
                        file, count = occ.split(':')
                        word_to_files[word].append((file, count))
                        if file not in file_relations:
                            file_relations[file] = set()
                        file_relations[file].add(word)

    # Crear un grafo no dirigido para PageRank
    G = nx.Graph()

    # Añadir nodos (archivos)
    for file in file_relations:
        G.add_node(file)

    # Añadir aristas entre archivos que comparten palabras
    for file1 in file_relations:
        for file2 in file_relations:
            if file1 != file2:
                shared_words = file_relations[file1].intersection(file_relations[file2])
                if shared_words:
                    G.add_edge(file1, file2, weight=len(shared_words))

    return G, word_to_files

# Construir el grafo a partir de 'index.txt' y guardar la relación palabra-archivos
graph, word_to_files = build_graph_from_index(file_path)

# Calcular PageRank utilizando MapReduce
def pagerank_mapreduce(graph, iterations=10):
    """ Calcula el PageRank utilizando MapReduce. """
    num_nodes = len(graph)
    nx.set_node_attributes(graph, 1 / num_nodes, 'rank')

    for i in range(iterations):
        contributions = map_phase(graph)
        new_ranks = reduce_phase(contributions, num_nodes=num_nodes)
        nx.set_node_attributes(graph, new_ranks, 'rank')

    return {node: graph.nodes[node]['rank'] for node in graph}

pagerank_scores = pagerank_mapreduce(graph)

# Escribir en index2.txt la palabra, los archivos donde aparece y su PageRank
output_file_path = 'index.txt'

with open(output_file_path, 'w', encoding='utf-8') as file:
    for word, occurrences in word_to_files.items():
        for file_name, count in occurrences:
            rank = pagerank_scores.get(file_name, 0)
            file.write(f"{word}\t{file_name}:{count}\tPageRank: {rank}\n")

output_file_path
