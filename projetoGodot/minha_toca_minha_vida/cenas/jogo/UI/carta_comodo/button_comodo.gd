class_name ButtonComodo
extends Button

@onready var rect_shader: TextureRect = %TextureRectShader

func _ready() -> void:
	rect_shader.hide()
	pressed.connect(clicado)

func clicado() -> void:
	rect_shader.show()

func desclicado() -> void:
	rect_shader.hide()
