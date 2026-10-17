class_name TesteGrafoComodos
extends Node

@export var recurso_testado := GerenciadorRecursos.Recurso.MORADIA

var adm: AdmGrafoComodos
var passou := 0
var falhou := 0

func _ready() -> void:
	adm = AdmGrafoComodos.new()
	add_child(adm)

	var casos := _criar_casos()
	for i in casos.size():
		_rodar_caso(i + 1, casos[i])

	print("==================================")
	print("Resultado: %d passaram, %d falharam (de %d)" % [passou, falhou, casos.size()])


# Execucao
# ------------------------------------------------------------------------------

func _rodar_caso(numero: int, caso: Dictionary) -> void:
	# coloca os comodos na ordem definida
	for item: Array in caso.colocar:
		adm.colocar_comodo(_criar_carta(item[1]), item[0])

	# compara com o esperado
	var erros: Array[String] = []
	for pos: Vector2i in caso.esperado:
		var esperado: int = caso.esperado[pos]
		var obtido: int = adm.grafo.quantidade(pos, recurso_testado)
		if obtido != esperado:
			erros.append("    %s esperado=%d obtido=%d" % [pos, esperado, obtido])

	# remove todos os comodos
	_remover_todos()
	if not adm.grafo.comodos.is_empty():
		erros.append("    grafo nao ficou vazio depois de remover tudo")

	if erros.is_empty():
		passou += 1
		print("[PASSOU]  %02d - %s" % [numero, caso.nome])
	else:
		falhou += 1
		print("[FALHOU]  %02d - %s" % [numero, caso.nome])
		for erro in erros:
			print(erro)

func _remover_todos() -> void:
	for pos: Vector2i in adm.grafo.comodos.keys():
		adm.grafo.remover(pos)

## Cria uma carta que gera Moradia 
## 0 = nao gera nada
func _criar_carta(emite: int) -> CartaRes:
	var carta := CartaRes.new()
	carta.recurso_gerado.clear()
	if emite > 0:
		carta.recurso_gerado[recurso_testado] = emite
	return carta


# Helpers para montar os casos
# ------------------------------------------------------------------------------

## Comodo a ser colocado: [posicao, quanto emite]
func _c(x: int, y: int, emite := 0) -> Array:
	return [Vector2i(x, y), emite]


func _caso(nome: String, colocar: Array, esperado: Dictionary) -> Dictionary:
	return {"nome": nome, "colocar": colocar, "esperado": esperado}


## Esperado para uma linha: valores[x] na posicao (x, y)
func _esperado_linha(y: int, valores: Array) -> Dictionary:
	var d := {}
	for x in valores.size():
		d[Vector2i(x, y)] = valores[x]
	return d


## Esperado para uma coluna: valores[y] na posicao (x, y)
func _esperado_coluna(x: int, valores: Array) -> Dictionary:
	var d := {}
	for y in valores.size():
		d[Vector2i(x, y)] = valores[y]
	return d


## Esperado na mesma ordem em que os comodos foram colocados
func _esperado_ordem(colocar: Array, valores: Array) -> Dictionary:
	var d := {}
	for i in colocar.size():
		d[colocar[i][0]] = valores[i]
	return d


# Casos
# ------------------------------------------------------------------------------

func _criar_casos() -> Array[Dictionary]:
	var casos: Array[Dictionary] = []
	var colocar: Array

	# ---------------------------- LINHAS ------------------------------------

	casos.append(_caso("Linha 0: emissor 3 na ponta",
		[_c(0, 0, 3), _c(1, 0), _c(2, 0), _c(3, 0), _c(4, 0)],
		_esperado_linha(0, [3, 2, 1, 0, 0])))

	casos.append(_caso("Linha 1: emissor 4 no meio",
		[_c(0, 1), _c(1, 1), _c(2, 1, 4), _c(3, 1), _c(4, 1)],
		_esperado_linha(1, [2, 3, 4, 3, 2])))

	# soma daria 3 no meio, o correto e pegar so o maior (2)
	casos.append(_caso("Linha 2: dois emissores (4 e 3), pega o maior e nao soma",
		[_c(0, 2, 4), _c(1, 2), _c(2, 2), _c(3, 2), _c(4, 2, 3)],
		_esperado_linha(2, [4, 3, 2, 2, 3])))

	# o comodo do meio entra por ultimo e liga as duas partes
	casos.append(_caso("Linha 3: comodo do meio colocado por ultimo liga o caminho",
		[_c(0, 3, 5), _c(1, 3), _c(3, 3), _c(4, 3), _c(2, 3)],
		_esperado_linha(3, [5, 4, 3, 2, 1])))

	# o emissor mais forte entra por ultimo e substitui valores menores
	casos.append(_caso("Linha 4: emissor forte colocado por ultimo sobrescreve",
		[_c(0, 4), _c(1, 4), _c(2, 4, 2), _c(3, 4), _c(4, 4, 5)],
		_esperado_linha(4, [1, 2, 3, 4, 5])))

	# ---------------------------- COLUNAS -----------------------------------

	casos.append(_caso("Coluna 0: emissor 3 embaixo",
		[_c(0, 0), _c(0, 1), _c(0, 2), _c(0, 3), _c(0, 4, 3)],
		_esperado_coluna(0, [0, 0, 1, 2, 3])))

	casos.append(_caso("Coluna 1: emissor 5 no meio",
		[_c(1, 0), _c(1, 1), _c(1, 2, 5), _c(1, 3), _c(1, 4)],
		_esperado_coluna(1, [3, 4, 5, 4, 3])))

	casos.append(_caso("Coluna 2: dois emissores iguais nas pontas (nao soma)",
		[_c(2, 0, 3), _c(2, 1), _c(2, 2), _c(2, 3), _c(2, 4, 3)],
		_esperado_coluna(2, [3, 2, 1, 2, 3])))

	casos.append(_caso("Coluna 3: comodo do meio colocado por ultimo liga o caminho",
		[_c(3, 0, 4), _c(3, 1), _c(3, 3), _c(3, 4), _c(3, 2)],
		_esperado_coluna(3, [4, 3, 2, 1, 0])))

	casos.append(_caso("Coluna 4: emissores 2 e 4 (pega o maior de cada lado)",
		[_c(4, 0), _c(4, 1, 2), _c(4, 2), _c(4, 3, 4), _c(4, 4)],
		_esperado_coluna(4, [1, 2, 3, 4, 3])))

	# --------------------------- DIAGONAIS ----------------------------------
	# A conexao e so por vizinho de cima/baixo/esquerda/direita,
	# entao comodos que se tocam apenas pela diagonal NAO se conectam.

	colocar = [_c(0, 0, 5), _c(1, 1), _c(2, 2), _c(3, 3), _c(4, 4)]
	casos.append(_caso("Diagonal principal: comodos so na diagonal nao se conectam",
		colocar, _esperado_ordem(colocar, [5, 0, 0, 0, 0])))

	colocar = [_c(4, 0), _c(3, 1), _c(2, 2, 5), _c(1, 3), _c(0, 4)]
	casos.append(_caso("Diagonal secundaria: comodos so na diagonal nao se conectam",
		colocar, _esperado_ordem(colocar, [0, 0, 5, 0, 0])))

	# escada ligando (0,0) a (4,4): o caminho tem 8 passos
	colocar = [_c(0, 0, 6), _c(1, 0), _c(1, 1), _c(2, 1), _c(2, 2),
			_c(3, 2), _c(3, 3), _c(4, 3), _c(4, 4)]
	casos.append(_caso("Escada na diagonal principal: emissor 6 no canto",
		colocar, _esperado_ordem(colocar, [6, 5, 4, 3, 2, 1, 0, 0, 0])))

	# escada ligando (4,0) a (0,4), emissor 4 no centro (2,2)
	colocar = [_c(4, 0), _c(3, 0), _c(3, 1), _c(2, 1), _c(2, 2, 4),
			_c(1, 2), _c(1, 3), _c(0, 3), _c(0, 4)]
	casos.append(_caso("Escada na diagonal secundaria: emissor 4 no centro",
		colocar, _esperado_ordem(colocar, [0, 1, 2, 3, 4, 3, 2, 1, 0])))

	# nas duas pontas da escada, o meio (2,2) recebe 0 de ambos
	colocar = [_c(0, 0, 4), _c(1, 0), _c(1, 1), _c(2, 1), _c(2, 2),
			_c(3, 2), _c(3, 3), _c(4, 3), _c(4, 4, 4)]
	casos.append(_caso("Escada na diagonal: emissores 4 nas duas pontas",
		colocar, _esperado_ordem(colocar, [4, 3, 2, 1, 0, 1, 2, 3, 4])))

	return casos
