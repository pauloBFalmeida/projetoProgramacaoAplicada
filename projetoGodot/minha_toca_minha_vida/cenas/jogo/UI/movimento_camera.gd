class_name MovimentoCamera
extends Control

@export var camera: CameraJogo
@export var sensibilidade := 1.0

@export var wheel_zoom_factor := 1.1

## Posicoes do touch (locais ao nodo) por indice do toque
var pos_por_touche_id := {}

var last_dist := 0.0
var last_meio := Vector2.ZERO
var mouse_dragging := false

func _gui_input(event: InputEvent) -> void:
	# --- Touch ---
	_input_touch(event)

	# --- Mouse (desktop) ---
	_input_mouse(event)

# Mouse
# ------------------------------------------------------------------------------

func _input_mouse(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# se for emulando o touch, pare
		if event.device == InputEvent.DEVICE_ID_EMULATION: return 
		# acao do botao
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				mouse_dragging = event.pressed
			MOUSE_BUTTON_WHEEL_UP:
				_zoom_posicao(wheel_zoom_factor, event.global_position)
			MOUSE_BUTTON_WHEEL_DOWN:
				_zoom_posicao(1.0 / wheel_zoom_factor, event.global_position)
		
		accept_event()

	elif event is InputEventMouseMotion:
		# se for emulando o touch, pare
		if event.device == InputEvent.DEVICE_ID_EMULATION: return 
		# se estiver segurando fazendo o dragging
		if mouse_dragging:
			_mover_camera(event.relative)
			accept_event()

# Touch
# ------------------------------------------------------------------------------

func _input_touch(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			pos_por_touche_id[event.index] = event.position
		else:
			pos_por_touche_id.erase(event.index)
		_atualizar_touch()
		accept_event()

	elif event is InputEventScreenDrag:
		pos_por_touche_id[event.index] = event.position
		if pos_por_touche_id.size() == 1:
			_mover_camera(event.relative)
		elif pos_por_touche_id.size() == 2:
			_update_pinch()
		accept_event()


func _atualizar_touch() -> void:
	if pos_por_touche_id.size() == 2:
		var poscioes := pos_por_touche_id.values()
		last_dist = poscioes[0].distance_to(poscioes[1])
		last_meio = (poscioes[0] + poscioes[1]) / 2.0
	else:
		last_dist = 0.0

func _update_pinch() -> void:
	var posicoes := pos_por_touche_id.values()
	var dist: float = posicoes[0].distance_to(posicoes[1])
	var meio: Vector2 = (posicoes[0] + posicoes[1]) / 2.0
	if last_dist > 0.0:
		_mover_camera(meio - last_meio)
		_zoom_posicao(dist / last_dist, meio)
	last_dist = dist
	last_meio = meio

# Movimento camera
# ------------------------------------------------------------------------------

func _mover_camera(relative: Vector2) -> void:
	camera.mover(-relative)

func _zoom_posicao(fator_zoom: float, global_pos_meio: Vector2) -> void:
	camera.zoom_posicao(fator_zoom, global_pos_meio)
