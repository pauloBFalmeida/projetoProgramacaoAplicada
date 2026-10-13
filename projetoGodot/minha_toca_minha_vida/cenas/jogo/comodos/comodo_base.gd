extends Node2D
class_name ComodoBase

@onready var sprite_borda: Sprite2D = $SpriteBorda
@onready var sprite_comodo: Sprite2D = $SpriteComodo

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	esconder()

func piscar_clicavel() -> void:
	area_2d.monitoring = true
	area_2d.monitorable = false
	
	sprite_comodo.hide()
	sprite_borda.show()
	
	sprite_borda.modulate.a = 0.2
	var tween := create_tween()
	tween.set_loops()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(
		sprite_borda, "modulate:a",
		0.4, 2.0
	)
	tween.tween_property(
		sprite_borda, "modulate:a",
		0.2, 2.0
	)

func esconder() -> void:
	#area_2d.monitoring = false
	#area_2d.monitorable = false
	sprite_comodo.hide()
	sprite_borda.hide()

func mostrar_comodo() -> void:
	sprite_comodo.show()
	sprite_borda.modulate.a = 1.0
