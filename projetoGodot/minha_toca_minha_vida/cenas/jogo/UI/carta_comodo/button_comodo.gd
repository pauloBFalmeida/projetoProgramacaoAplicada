class_name ButtonComodo
extends Button

@onready var rect_shader: TextureRect = %TextureRectShader
@onready var texture_rect_comodo: TextureRect = $TextureRectComodo

func _ready() -> void:
	rect_shader.hide()
	pressed.connect(clicado)

func clicado() -> void:
	rect_shader.show()

func desclicado() -> void:
	rect_shader.hide()

func get_textura_comodo() -> Texture:
	return  texture_rect_comodo.texture
