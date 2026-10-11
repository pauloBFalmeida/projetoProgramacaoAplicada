class_name Jogo
extends Node

@onready var background: Background = $Mundo/Background
@onready var camera_2d: Camera2D = $Mundo/Camera2D

func _process(delta: float) -> void:
	var pos := camera_2d.global_position
	pos.y += 720
	background.aumentar_ate(pos)
