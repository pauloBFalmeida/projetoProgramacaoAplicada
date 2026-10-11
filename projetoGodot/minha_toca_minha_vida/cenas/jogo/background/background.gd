class_name Background
extends Node2D

## Quantidade de linhas de tiles extras alem da global_pos_final 
@export var tiles_extras_vert := 4

var global_pos_final_y : float = 100

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

func aumentar_ate(global_pos: Vector2) -> void:
	if global_pos.y <= global_pos_final_y: return
	
	var tile_pos := tile_map_layer.local_to_map(tile_map_layer.to_local(global_pos))
	var tile_pos_final := tile_map_layer.local_to_map(tile_map_layer.to_local(Vector2(0, global_pos_final_y)))
	
	var linha : int = tile_pos.y
	var linha_final : int = tile_pos_final.y
	
	for y in range(linha_final+tiles_extras_vert, linha+tiles_extras_vert):
		for x in range(-1, 10):
			var tile := Vector2(x, y)
			tile_map_layer.set_cell(tile, 0, Vector2i.ZERO)
	
	global_pos_final_y = global_pos.y
