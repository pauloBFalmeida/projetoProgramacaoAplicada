class_name Background
extends Node2D

## Quantidade de linhas de tiles extras alem da global_pos_final 
@export var tiles_extras_vert := 3
## Quantidade de colunas de tiles extras para cada da tela
@export var tiles_extras_laterais := 3

var global_pos_final_y : float = 100
var tile_pos_laterais_ini : int
var tile_pos_laterais_fim : int

var screensize : Vector2i

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

func _ready() -> void:
	screensize = get_viewport().size
	
	var tile_final := tile_map_layer.local_to_map(tile_map_layer.to_local(screensize))
	tile_pos_laterais_ini = - tiles_extras_laterais
	tile_pos_laterais_fim = tile_final.x + tiles_extras_laterais
	

func aumentar_ate_cam(global_pos_cam: Vector2) -> void:
	global_pos_cam.y += screensize.y
	aumentar_ate(global_pos_cam)

func aumentar_ate(global_pos: Vector2) -> void:
	if global_pos.y <= global_pos_final_y: return
	
	var tile_pos := tile_map_layer.local_to_map(tile_map_layer.to_local(global_pos))
	var tile_pos_final := tile_map_layer.local_to_map(tile_map_layer.to_local(Vector2(0, global_pos_final_y)))
	
	var linha : int = tile_pos.y
	var linha_final : int = tile_pos_final.y
	
	for y in range(linha_final+tiles_extras_vert, linha+tiles_extras_vert):
		for x in range(tile_pos_laterais_ini, tile_pos_laterais_fim):
			var tile := Vector2(x, y)
			tile_map_layer.set_cell(tile, 2, Vector2i.ZERO)
	
	global_pos_final_y = global_pos.y
