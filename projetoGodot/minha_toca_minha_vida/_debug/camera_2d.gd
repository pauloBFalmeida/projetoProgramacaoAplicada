class_name CameraJogo
extends Camera2D

@export var min_zoom := 1.0
@export var max_zoom := 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mov := Input.get_axis("ui_up", "ui_down")
	position.y += mov * delta * 200
	_limitar_posicao()

func mover(direcao: Vector2) -> void:
	print(direcao)
	position += direcao / zoom
	_limitar_posicao()

func zoom_posicao(fator_zoom: float, pos_tela: Vector2) -> void:
	var zoom_antigo := zoom.x
	var zoom_novo := clampf(zoom_antigo * fator_zoom, min_zoom, max_zoom)
	if is_equal_approx(zoom_antigo, zoom_novo): return

	# vai em direcao a onde o zoom foi feito
	var offset := pos_tela - (get_viewport_rect().size / 2.0)
	position += offset / zoom_antigo - offset / zoom_novo
	
	zoom = Vector2.ONE * zoom_novo


func _limitar_posicao() -> void:
	if position.y < limit_top: position.y = limit_top
	
	var limit_right_zoom = limit_right - (1280 / zoom.x)
	
	if position.x < limit_left: 
		position.x = limit_left
	elif position.x > limit_right_zoom: 
		position.x = limit_right_zoom
