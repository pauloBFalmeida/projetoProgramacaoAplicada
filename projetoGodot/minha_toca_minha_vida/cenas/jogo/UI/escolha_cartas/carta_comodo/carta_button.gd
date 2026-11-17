class_name CartaButton
extends Button

signal clicado_rapido
signal esta_segurado

## Tempo que tem que segurar para considerar pega em segundos
@export var tempo_click_pegar := 0.12

@export var texture_rect_comodo: TextureRect
@export var texture_rect_shader: TextureRect

@onready var timer_verifica_segurado: Timer = $TimerVerificaSegurado

var carta_res: CartaRes


func _ready() -> void:
	texture_rect_shader.hide()
	
	button_down.connect(_on_apertado)
	button_up.connect(_on_solto)
	
	timer_verifica_segurado.timeout.connect(_timer_verifica_segurado_timeout)

func set_carta_res(_carta_res: CartaRes) -> void:
	carta_res = _carta_res
	set_textura_comodo(carta_res.imagem)

#func clicado() -> void:
	#texture_rect_shader.show()
#
#func desclicado() -> void:
	#texture_rect_shader.hide()

func set_textura_comodo(textura: Texture) -> void:
	texture_rect_comodo.texture = textura

func get_textura_comodo() -> Texture:
	return  texture_rect_comodo.texture

func get_carta() -> CartaRes:
	return carta_res



func _on_apertado() -> void:
	timer_verifica_segurado.start(tempo_click_pegar)

func _on_solto() -> void:
	# se o timer esta correndo, entao foi antes dele terminar
	if not timer_verifica_segurado.is_stopped():
		# para o timer, e avisa que foi click rapido
		timer_verifica_segurado.stop()
		clicado_rapido.emit()

func _timer_verifica_segurado_timeout() -> void:
	esta_segurado.emit()
