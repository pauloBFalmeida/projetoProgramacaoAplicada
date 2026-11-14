extends Node2D
class_name ComodoBase

@onready var sprite_borda: Sprite2D = $SpriteBorda
@onready var sprite_comodo: Sprite2D = $SpriteComodo
@onready var area_2d: Area2D = $Area2D

var grid_pos : Vector2i
var ocupado : bool = false
var disponivel : bool = false

var tween_piscar : Tween

func _ready() -> void:
	esconder()
	#name = "ComodoBase(%d, %d)" % [grid_pos.x, grid_pos.y]

## Mostra a borda piscando (posicao disponivel para receber um comodo)
func piscar_clicavel() -> void:	
	_parar_tween()
	area_2d.monitorable = true
	
	sprite_comodo.hide()
	sprite_borda.show()
	
	sprite_borda.modulate.a = 0.2
	tween_piscar = create_tween()
	tween_piscar.set_loops()
	tween_piscar.set_ease(Tween.EASE_IN_OUT)
	tween_piscar.set_trans(Tween.TRANS_QUAD)
	tween_piscar.tween_property(sprite_borda, "modulate:a", 0.4, 1.5)
	tween_piscar.tween_property(sprite_borda, "modulate:a", 0.1, 1.5)

func esconder() -> void:
	_parar_tween()
	area_2d.monitorable = false
	sprite_comodo.hide()
	sprite_borda.hide()

## Coloca o comodo definitivamente nesta posicao
func ocupar(textura: Texture2D) -> void:
	ocupado = true
	disponivel = false
	
	_parar_tween()
	area_2d.monitorable = false
	sprite_comodo.texture = textura
	sprite_comodo.show()
	sprite_borda.show()
	sprite_borda.modulate.a = 1.0

func _parar_tween() -> void:
	if tween_piscar and tween_piscar.is_valid():
		tween_piscar.kill()
