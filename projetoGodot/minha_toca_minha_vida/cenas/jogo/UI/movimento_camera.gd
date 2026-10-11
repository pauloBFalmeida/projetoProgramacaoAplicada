class_name MovimentoCamera
extends Control

@export var camera: Camera2D
@export var sensibilidade := 1.0

@export var min_zoom := 1.0
@export var max_zoom := 2.0
@export var wheel_zoom_factor := 1.1

var touches := {}            # finger index -> position
var last_dist := 0.0
var last_mid := Vector2.ZERO
var mouse_dragging := false

func _gui_input(event: InputEvent) -> void:
	# --- Touch ---
	if event is InputEventScreenTouch:
		if event.pressed:
			touches[event.index] = event.position
		else:
			touches.erase(event.index)
		_reset_pinch()
		accept_event()

	elif event is InputEventScreenDrag:
		touches[event.index] = event.position
		if touches.size() == 1:
			_pan(event.relative)
		elif touches.size() == 2:
			_update_pinch()
		accept_event()

	# --- Mouse (desktop) ---
	elif event is InputEventMouseButton:
		if event.device == InputEvent.DEVICE_ID_EMULATION:
			return # emulated from touch, already handled above
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				mouse_dragging = event.pressed
			MOUSE_BUTTON_WHEEL_UP:
				_zoom_at(event.position, wheel_zoom_factor)
			MOUSE_BUTTON_WHEEL_DOWN:
				_zoom_at(event.position, 1.0 / wheel_zoom_factor)
		accept_event()

	elif event is InputEventMouseMotion:
		if event.device == InputEvent.DEVICE_ID_EMULATION:
			return
		if mouse_dragging:
			_pan(event.relative)
			accept_event()

	# --- Trackpad pinch (macOS) ---
	elif event is InputEventMagnifyGesture:
		_zoom_at(event.position, event.factor)
		accept_event()

func _pan(relative: Vector2) -> void:
	camera.position -= relative / camera.zoom

func _reset_pinch() -> void:
	if touches.size() == 2:
		var pts := touches.values()
		last_dist = pts[0].distance_to(pts[1])
		last_mid = (pts[0] + pts[1]) / 2.0
	else:
		last_dist = 0.0

func _update_pinch() -> void:
	var pts := touches.values()
	var dist: float = pts[0].distance_to(pts[1])
	var mid: Vector2 = (pts[0] + pts[1]) / 2.0
	if last_dist > 0.0:
		_pan(mid - last_mid)                 # two-finger drag also moves the camera
		_zoom_at(mid, dist / last_dist)      # spreading fingers = zoom in
	last_dist = dist
	last_mid = mid

func _zoom_at(focus: Vector2, factor: float) -> void:
	var old_zoom := camera.zoom.x
	var new_zoom := clampf(old_zoom * factor, min_zoom, max_zoom)
	# Keep the world point under the focus fixed on screen
	var offset := focus + global_position - get_viewport_rect().size / 2.0
	camera.position += offset / old_zoom - offset / new_zoom
	camera.zoom = Vector2(new_zoom, new_zoom)
