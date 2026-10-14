class_name CartaSegurada
extends CharacterBody2D

signal solto_em_area(area: Area2D)
signal solto_fora

@onready var sprite_comodo: Sprite2D = $SpriteComodo

var arrastando := false

func iniciar_arraste() -> void:
	arrastando = true
	global_position = get_global_mouse_position()

func _process(_delta: float) -> void:
	if not arrastando: return
	# segue o mouse
	global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if not arrastando: return
	
	# soltar o botao do mouse
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and not event.pressed:
		_soltar()
	# soltar o touch
	elif event is InputEventScreenTouch and not event.pressed:
		_soltar()
	# arrastar com o touch, mover a carta
	elif event is InputEventScreenDrag:
		position = event.position

func _soltar() -> void:
	arrastando = false
	
	var area := _area_sob_ponto(global_position)
	if area:
		 #encaixa no slot
		#global_position = area.global_position
		solto_em_area.emit(area)
	else:
		# se for fora, nao faca nada 
		solto_fora.emit()
		#queue_free()

## Pega a area em baixo do local que a carta esta
func _area_sob_ponto(pos: Vector2) -> Area2D:
	var query := PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var resultado := get_world_2d().direct_space_state.intersect_point(query, 1)
	if resultado.is_empty(): return null
	
	# se for uma area monitoravel, retorne a area
	var area : Area2D = resultado[0].collider
	if area.monitorable:
		return area
	
	return null

func set_textura(textura: Texture) -> void:
	sprite_comodo.texture = textura
