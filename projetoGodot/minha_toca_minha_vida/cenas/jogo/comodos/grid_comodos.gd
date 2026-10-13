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

var grid : Dictionary[Vector2i, Node2D] = {}

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
			grid[Vector2i(x,y)] = posicao
			var comodo := COMODO_BASE.instantiate() as ComodoBase
			posicao.add_child(comodo)
			if x > 0 and x < 4 and y == 0:
				comodo.piscar_clicavel()
			
