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
			

func pegar_comodo(area: Area2D) -> ComodoBase:
	for comodo : ComodoBase in comodos_grid.keys():
		if comodo.area_2d == area:
			return comodo
	return null

func get_grid_pos(comodo: ComodoBase) -> Vector2i:
	if comodos_grid.has(comodo):
		return comodos_grid[comodo]
	return Vector2i.MIN

func get_comodo(grid_pos: Vector2i) -> ComodoBase:
	if comodos_por_pos.has(grid_pos):
		return comodos_por_pos[grid_pos]
	return null

func liberar_comodo(grid_pos: Vector2i) -> void:
	var comodo : ComodoBase = get_comodo(grid_pos)
	comodos_liberados.append(comodo)
	comodo.piscar_clicavel()

func _bloquear_comodo(comodo : ComodoBase) -> void:
	comodos_liberados.erase(comodo)
	comodo.mostrar_comodo()

func bloquear_comodo(grid_pos: Vector2i) -> void:
	var comodo : ComodoBase = get_comodo(grid_pos)
	_bloquear_comodo(comodo)

func bloquear_comodo_area(area: Area2D) -> void:
	var comodo : ComodoBase = pegar_comodo(area)
	_bloquear_comodo(comodo)


func set_piscar_comodos(piscar: bool = true) -> void:
	for comodo : ComodoBase in comodos_liberados:
		if piscar:
			comodo.piscar_clicavel()
		else:
			comodo.esconder()
