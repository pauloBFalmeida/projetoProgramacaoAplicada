extends Node2D
class_name ComodoBase

@onready var sprite_borda: Sprite2D = $SpriteBorda
@onready var sprite_comodo: Sprite2D = $SpriteComodo

@onready var area_2d: Area2D = $Area2D

var tween_piscar : Tween

func _ready() -> void:
	esconder()

func piscar_clicavel() -> void:
	area_2d.monitorable = true
	
	sprite_comodo.hide()
	sprite_borda.show()
	
	sprite_borda.modulate.a = 0.2
	tween_piscar = create_tween()
	tween_piscar.set_loops()
	tween_piscar.set_ease(Tween.EASE_IN_OUT)
	tween_piscar.set_trans(Tween.TRANS_QUAD)
	tween_piscar.tween_property(
		sprite_borda, "modulate:a",
		0.4, 1.5
	)
	tween_piscar.tween_property(
		sprite_borda, "modulate:a",
		0.1, 1.5
	)

func esconder() -> void:
	area_2d.monitorable = false
	sprite_comodo.hide()
	sprite_borda.hide()

func mostrar_comodo() -> void:
	area_2d.monitorable = false
	sprite_comodo.show()
	if tween_piscar.is_running(): tween_piscar.kill()
	sprite_borda.modulate.a = 1.0

func set_textura_comodo(textura: Texture2D) -> void:
	sprite_comodo.texture = textura
