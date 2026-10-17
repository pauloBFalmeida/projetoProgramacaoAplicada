class_name AdmGrafoComodos
extends Node

var grafo := GrafoComodos.new()

func colocar_comodo(carta_comodo: CartaRes, pos: Vector2i) -> void:
	if grafo.comodos.has(pos): return
	grafo.colocar(pos, carta_comodo)

# TODO: TESTES SOMENTE
func _ready() -> void:
	grafo.atualizado.connect(_on_grafo_atualizado)

func _on_grafo_atualizado() -> void:
	print("--------------------------")
	for pos in grafo.comodos:
		print(pos, " Moradia=", grafo.quantidade(pos, GerenciadorRecursos.Recurso.MORADIA))

# Nodo Comodo
# -----------------------------------------------------------------------------

## Nodo que representa um comodo do tabuleiro [br]
## Guarda a carta e os valores que recebe
class NodoComodo:
	extends RefCounted
	
	## Avisa quando o nodo tiver valores alterados
	signal alterado
	
	## Posicao na grid
	var pos: Vector2i
	## Carta Resource referente e esse comodo
	var carta: CartaRes

	## Quanto que recebe de um dado recurso [br]
	## Inclusive o quanto emite
	var qtd_recursos: Dictionary[GerenciadorRecursos.Recurso, int] = {}

	func _init(_pos: Vector2i, _carta: CartaRes) -> void:
		pos = _pos
		carta = _carta
	
	## Retorna a quantidade de Recurso que esse nodo tem
	func quantidade(recurso: GerenciadorRecursos.Recurso) -> int:
		return qtd_recursos.get(recurso, 0)

	## Guarda o valor so se for maior que o atual [br]
	## Retorna true se mudou, e false se nao houve alteracao
	func receber(recurso: GerenciadorRecursos.Recurso, qtd: int) -> bool:
		# se recebe menos ou igual do que tinha, nao altere
		if qtd <= quantidade(recurso): 
			return false
		# se recebe mais, altere
		qtd_recursos[recurso] = qtd
		return true
	
	func emitir_alterado() -> void:
		alterado.emit()

# Grafo Comodo
# -----------------------------------------------------------------------------

## Grafo dos comodos
class GrafoComodos:
	extends RefCounted

	## Emitido quando algum valor do grafo mudou
	signal atualizado

	## Direcoes para serem adicionadas a posicao na grid, 
	## para se obter as posicoes da grid vizinhos conectados
	const DIRECOES: Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

	## NodoComodos por posicao na grid
	var comodos: Dictionary[Vector2i, NodoComodo] = {}

	## Retorna a quantidade de um Recurso em uma posicao da grid
	func quantidade(pos: Vector2i, recurso: GerenciadorRecursos.Recurso) -> int:
		# se nao tiver, retorne 0
		if not comodos.has(pos): return 0
		# se tiver, retorne a quantidade
		return comodos[pos].quantidade(recurso)

	## Posicoes vizinhas que possuem comodo
	func vizinhos_pos(pos: Vector2i) -> Array[Vector2i]:
		var resultado: Array[Vector2i] = []
		for direcao in DIRECOES:
			var vizinho_pos := pos + direcao
			if comodos.has(vizinho_pos):
				resultado.append(vizinho_pos)
		return resultado

	## Coloca um comodo e atualiza so o que for afetado por ele
	func colocar(pos: Vector2i, carta: CartaRes) -> void:
		var nodo := NodoComodo.new(pos, carta)
		comodos[pos] = nodo
		# calcula o que ele gera, e adiciona o melhor que cada vizinho gera -1
		var _recursos: Dictionary = carta.recurso_gerado.duplicate()
		for vizinho_pos in vizinhos_pos(pos):
			var _vizinho : NodoComodo = comodos[vizinho_pos]
			# pega os recursos que cada vizinho tem
			for recurso in _vizinho.qtd_recursos.keys():
				var qtd: int = _vizinho.qtd_recursos[recurso] - 1
				# se for maior do que atual, entao recebe
				if qtd > _recursos.get(recurso, 0):
					_recursos[recurso] = qtd

		# espalha a partir dele
		var alterados := {}
		_espalhar(pos, _recursos, alterados)
		_notificar(alterados)

	## Remove comodo [br]
	## Valores podem diminuir, entao recalcula tudo
	func remover(pos: Vector2i) -> void:
		comodos.erase(pos)

		var antes := {}
		for nodo: NodoComodo in comodos.values():
			antes[nodo] = nodo.qtd_recursos
			nodo.qtd_recursos = {}

		var ignorado := {}
		for nodo: NodoComodo in comodos.values():
			_espalhar(nodo.pos, nodo.carta.recurso_gerado, ignorado)

		# So avisa quem realmente mudou
		var alterados := {}
		for nodo: NodoComodo in comodos.values():
			if nodo.qtd_recursos != antes[nodo]:
				alterados[nodo] = true
		_notificar(alterados)

	## Aplica "valores" em "origem" e propaga para os vizinhos perdendo 1 por passo.
	## So continua por um caminho enquanto o valor novo for maior que o que o nodo ja tem
	func _espalhar(origem: Vector2i, valores: Dictionary, alterados: Dictionary) -> void:
		var nodo_origem := comodos[origem]

		for recurso in valores:
			if not nodo_origem.receber(recurso, valores[recurso]):
				continue
			alterados[nodo_origem] = true

			var fila: Array[Vector2i] = [origem]
			var i := 0
			while i < fila.size():
				var atual := fila[i]
				i += 1

				var proximo: int = comodos[atual].quantidade(recurso) - 1
				if proximo <= 0: continue

				for vizinho_pos in vizinhos_pos(atual):
					var vizinho : NodoComodo = comodos[vizinho_pos]
					if vizinho.receber(recurso, proximo):
						alterados[vizinho] = true
						fila.append(vizinho_pos)

	func _notificar(alterados: Dictionary) -> void:
		if alterados.is_empty(): return
		for nodo: NodoComodo in alterados:
			nodo.emitir_alterado()
		atualizado.emit()
