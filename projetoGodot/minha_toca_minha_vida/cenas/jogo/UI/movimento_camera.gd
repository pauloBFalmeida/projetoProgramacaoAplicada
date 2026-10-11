class_name MovimentoCamera
extends Control

@export var camera: Camera2D
@export var sensibilidade := 1.0

@export var min_zoom := 1.0
@export var max_zoom := 2.0
@export var wheel_zoom_factor := 1.1


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
				_zoom_posicao(event.position, wheel_zoom_factor)
			MOUSE_BUTTON_WHEEL_DOWN:
				_zoom_posicao(event.position, 1.0 / wheel_zoom_factor)
		
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
	var pts := pos_por_touche_id.values()
	var dist: float = pts[0].distance_to(pts[1])
	var meio: Vector2 = (pts[0] + pts[1]) / 2.0
	if last_dist > 0.0:
		_mover_camera(meio - last_meio)
		_zoom_posicao(meio, dist / last_dist)
	last_dist = dist
	last_meio = meio

# Movimento camera
# ------------------------------------------------------------------------------

func _mover_camera(relative: Vector2) -> void:
	camera.position -= relative / camera.zoom

func _zoom_posicao(focus: Vector2, factor: float) -> void:
	var old_zoom := camera.zoom.x
	var new_zoom := clampf(old_zoom * factor, min_zoom, max_zoom)
	# Keep the world point under the focus fixed on screen
	var offset := focus + global_position - get_viewport_rect().size / 2.0
	camera.position += offset / old_zoom - offset / new_zoom
	camera.zoom = Vector2.ONE * new_zoom
