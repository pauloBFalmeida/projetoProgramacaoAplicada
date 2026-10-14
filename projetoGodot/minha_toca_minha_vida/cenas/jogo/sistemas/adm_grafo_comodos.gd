class_name AdmGrafoComodos
extends Node

var grafo := GrafoComodos.new()

func _ready() -> void:
	grafo.atualizado.connect(_on_grafo_atualizado)

func colocar_comodo(carta_comodo: CartaRes, pos: Vector2i) -> void:
	if grafo.comodos.has(pos): return
	
	grafo.colocar(pos, carta_comodo)

func _on_grafo_atualizado() -> void:
	print("--------------------------")
	for pos in grafo.comodos:
		
		#print(pos, " Moedas=", grafo.valor(pos, GerenciadorRecursos.Recurso.MOEDAS))
		print(pos, " Moradia=", grafo.valor(pos, GerenciadorRecursos.Recurso.MORADIA))

## Grafo dos comodos
class GrafoComodos:
	extends RefCounted

	## Emitdo ao atualizar com um novo comodo adicionado
	signal atualizado
	
	## Direcao na grid a ser adicionado na posicao do comodo
	const DIRECOES: Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	
	## Comodos por posicao na grid
	var comodos: Dictionary[Vector2i, CartaRes] = {}
	
	## Dict de [recurso, valor] que cada comodo recebe (pela posicao)
	## [br] pos -> { atributo: valor recebido }
	var recebido: Dictionary[Vector2i, Dictionary] = {}

	## Coloca comodo na posicao da grid
	func colocar(pos: Vector2i, comodo: CartaRes) -> void:
		comodos[pos] = comodo
		recalcular()

	## remove uma posicao da grid
	func remover(pos: Vector2i) -> void:
		comodos.erase(pos)
		recalcular()

	## Retorna as posicoes vizinhos do nodo
	func vizinhos(pos: Vector2i) -> Array[Vector2i]:
		var resultado: Array[Vector2i] = []
		for d in DIRECOES:
			var p := pos + d
			if comodos.has(p):
				resultado.append(p)
		return resultado

	## Retorna o valor de um Recurso em uma posicao
	func valor(pos: Vector2i, atributo: GerenciadorRecursos.Recurso) -> int:
		return recebido.get(pos, {}).get(atributo, 0)

	## Recalcula os recursos pelo grafo
	func recalcular() -> void:
		recebido.clear()
		for pos in comodos:
			recebido[pos] = {}
		for origem in comodos:
			_propagar(origem)
		atualizado.emit()

	## Propaga os recursos de um nodo origem para os outros
	func _propagar(origem: Vector2i) -> void:
		var emite := comodos[origem].recurso_gerado
		if emite.is_empty(): return
	
		# o maior valor define ate onde vale a pena andar
		var alcance: int = emite.values().max()
	
		_BFS(origem, emite, alcance)

	## Breadth First Search (Busca em largura) [br]
	## Explora todos os nodos ate alcance, percorrendo os mais proximos primeiro
	func _BFS(origem: Vector2i, emite: Dictionary, alcance: int) -> void:
		var dist := {origem: 0}
		var fila: Array[Vector2i] = [origem]
		var i := 0
		while i < fila.size():
			var atual := fila[i]
			i += 1
			var d: int = dist[atual]

			for attr in emite:
				var v: int = emite[attr] - d   # perde 1 por passo
				if v > 0:
					recebido[atual][attr] = recebido[atual].get(attr, 0) + v

			if d + 1 >= alcance:
				continue                        # o próximo já chegaria com valor <= 0
			for viz in vizinhos(atual):
				if not dist.has(viz):
					dist[viz] = d + 1
					fila.append(viz)
