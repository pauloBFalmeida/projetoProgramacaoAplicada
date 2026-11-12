extends Node2D
class_name GridComodos

@export var pos_ini : Node2D
@export var pos_end_x : Node2D
@export var pos_next_y : Node2D

var _pos_ini : Vector2
var _pos_end_x : Vector2
var _pos_next_y : Vector2

const max_x : int = 5
const max_y : int = 10
const COMODO_BASE = preload("uid://dvqy4auvlk8jy")

var comodos_grid : Dictionary[ComodoBase, Vector2i] = {}
var comodos_por_pos : Dictionary[Vector2i, ComodoBase] = {}

var comodos_liberados : Array[ComodoBase] = []
var comodos_bloqueados : Array[ComodoBase] = []

func _ready() -> void:
	_pos_ini = pos_ini.global_position
	_pos_end_x = pos_end_x.global_position
	_pos_next_y = pos_next_y.global_position
	
	for c in get_children(): c.queue_free()
	
	_criar_grid()

# cria a grid
func _criar_grid() -> void:
	var incremento_x: float = (_pos_end_x.x - _pos_ini.x) / (max_x -1)
	var incremento_y: float = (_pos_next_y.y - _pos_ini.y)
	for y in range(max_y):
		for x in range(max_x):
			# posicao na grid
			var posicao := Node2D.new()
			add_child(posicao)
			posicao.position = Vector2(
				_pos_ini.x + (x * incremento_x),
				_pos_ini.y + (y * incremento_y),
			)
			var comodo := COMODO_BASE.instantiate() as ComodoBase
			var pos_grid := Vector2i(x,y)
			comodos_grid[comodo] = pos_grid
			comodos_por_pos[pos_grid] = comodo
			posicao.add_child(comodo)
			#if x == 2 and y == 0:
			#comodo.piscar_clicavel()
			

func get_comodo_from_area(area: Area2D) -> ComodoBase:
	for comodo : ComodoBase in comodos_grid.keys():
		if comodo.area_2d == area:
			return comodo
	return null

func get_grid_pos_from_comodo(comodo: ComodoBase) -> Vector2i:
	if comodos_grid.has(comodo):
		return comodos_grid[comodo]
	return Vector2i.MIN

func get_comodo_from_grid_pos(grid_pos: Vector2i) -> ComodoBase:
	if comodos_por_pos.has(grid_pos):
		return comodos_por_pos[grid_pos]
	return null

## Retorna uma lista de posicoes que nao estao bloqueadas ao redor do comodo
func get_posicoes_redor_validas_comodo(grid_pos: Vector2i) -> Array[Vector2i]:
	if not comodos_por_pos.has(grid_pos): return []
	
	const posicoes_redor : Array[Vector2i] = [
		Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT
	]
	
	var posicoes_validas_redor : Array[Vector2i] = []
	
	# verifica as posicoes do lado do comodo, por comodos validos (existentes e nao bloqueados)
	for pos_redor: Vector2i in posicoes_redor:
		var _pos := pos_redor + grid_pos
		var _comodo := get_comodo_from_grid_pos(_pos) 
		if _comodo and not comodos_bloqueados.has(_comodo):
			posicoes_validas_redor.append(_pos)
	
	return posicoes_validas_redor

func liberar_redor_comodo(grid_pos: Vector2i) -> void:
	for _pos : Vector2i in get_posicoes_redor_validas_comodo(grid_pos):
		liberar_comodo(_pos)

func liberar_comodo(grid_pos: Vector2i) -> void:
	var comodo : ComodoBase = get_comodo_from_grid_pos(grid_pos)
	if comodo:
		comodos_liberados.append(comodo)

func _bloquear_comodo(comodo : ComodoBase) -> void:
	comodos_liberados.erase(comodo)
	comodos_bloqueados.append(comodo)

func bloquear_comodo(grid_pos: Vector2i) -> void:
	var comodo : ComodoBase = get_comodo_from_grid_pos(grid_pos)
	if comodo: 
		_bloquear_comodo(comodo)


func set_piscar_comodos(piscar: bool = true) -> void:
	for comodo : ComodoBase in comodos_liberados:
		if piscar:
			comodo.piscar_clicavel()
		else:
			comodo.esconder()
