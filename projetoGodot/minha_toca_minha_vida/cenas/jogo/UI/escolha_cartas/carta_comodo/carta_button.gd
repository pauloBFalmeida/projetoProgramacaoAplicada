class_name CartaButton
extends Button

@export var texture_rect_comodo: TextureRect
@export var texture_rect_shader: TextureRect

var carta_res: CartaRes

func _ready() -> void:
	texture_rect_shader.hide()

func set_carta_res(_carta_res: CartaRes) -> void:
	carta_res = _carta_res
	set_textura_comodo(carta_res.imagem)

func clicado() -> void:
	texture_rect_shader.show()

func desclicado() -> void:
	texture_rect_shader.hide()

func set_textura_comodo(textura: Texture) -> void:
	texture_rect_comodo.texture = textura

func get_textura_comodo() -> Texture:
	return  texture_rect_comodo.texture

func get_carta() -> CartaRes:
	return carta_res
