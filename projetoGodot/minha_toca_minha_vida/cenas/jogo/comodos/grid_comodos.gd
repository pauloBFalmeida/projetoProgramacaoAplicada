extends Node2D
class_name GridComodos

@export var pos_ini : Node2D
@export var pos_end_x : Node2D
@export var pos_next_y : Node2D

const MAX_X : int = 5
const MAX_Y : int = 20

const POS_CARTA_INICIAL := Vector2i(2, 0)

const COMODO_BASE : PackedScene = preload("uid://dvqy4auvlk8jy")

const DIRECOES : Array[Vector2i] = [
	Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT
]

var comodos_por_pos : Dictionary[Vector2i, ComodoBase] = {}

func _ready() -> void:
	for c in get_children(): c.queue_free()
	_criar_grid()
	# habilitar a posicao inicial
	comodos_por_pos[POS_CARTA_INICIAL].disponivel = true

func _criar_grid() -> void:
	var inicio : Vector2 = pos_ini.global_position
	var incremento_x : float = (pos_end_x.global_position.x - inicio.x) / (MAX_X - 1)
	var incremento_y : float = pos_next_y.global_position.y - inicio.y
	for y in range(MAX_Y):
		for x in range(MAX_X):
			var posicao := Node2D.new()
			add_child(posicao)
			posicao.global_position = Vector2(
				inicio.x + (x * incremento_x),
				inicio.y + (y * incremento_y),
			)
			var comodo := COMODO_BASE.instantiate() as ComodoBase
			comodo.grid_pos = Vector2i(x, y)
			comodos_por_pos[comodo.grid_pos] = comodo
			posicao.add_child(comodo)

## A Area2D e filha direta do ComodoBase
func get_comodo_from_area(area: Area2D) -> ComodoBase:
	return area.get_parent() as ComodoBase

## Deixa disponivel os comodos nos 4 cantos de um comodo
## se o comodo vizinho nao estiver ocupao
func disponibilizar_vizinhos(comodo : ComodoBase) -> void:
	for dir : Vector2i in DIRECOES:
		var vizinho : ComodoBase = comodos_por_pos.get(comodo.grid_pos + dir)
		if not vizinho: continue
		# se nao estiver ocupado, entao esta disponivel
		if not vizinho.ocupado:
			vizinho.disponivel = true

func get_comodos_ocupados() -> Array[ComodoBase]:
	return comodos_por_pos.values().filter(func(comodo: ComodoBase): return comodo.ocupado)

func get_comodos_satisfeitos() -> Array[ComodoBase]:
	return comodos_por_pos.values().filter(func(comodo: ComodoBase): return comodo.satisfeito)

# Posicoes de comodos disponiveis
# -----------------------------------------------------------------------------

## Faz piscar todas as posicoes onde um comodo pode ser colocado
func mostrar_posicoes_disponiveis() -> void:
	for comodo : ComodoBase in comodos_por_pos.values():
		if comodo.disponivel:
			comodo.piscar_clicavel()

## Esconde as posicoes vazias
func esconder_posicoes() -> void:
	for comodo : ComodoBase in comodos_por_pos.values():
		if comodo.disponivel:
			comodo.esconder()

# Recursos nos comodos
# -----------------------------------------------------------------------------

func esconder_recursos() -> void:
	for comodo : ComodoBase in comodos_por_pos.values():
		if comodo.ocupado:
			comodo.esconder_recursos()
