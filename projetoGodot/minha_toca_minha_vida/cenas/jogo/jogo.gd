class_name Jogo
extends Node

@onready var background: Background = $Mundo/Background
@onready var camera_2d: Camera2D = $Mundo/Camera2D

func _process(delta: float) -> void:
	background.aumentar_ate_cam(camera_2d.global_position)
