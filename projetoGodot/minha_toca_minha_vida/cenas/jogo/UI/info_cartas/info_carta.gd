class_name InfoCarta
extends Control

const TEXTURE_RECURSO = preload("uid://5vwist4yl1rk")

@onready var texture_comodo: TextureRect = %TextureComodo
@onready var label_nome: Label = %LabelNome
@onready var h_box_prod: HBoxContainer = %HBoxProd
@onready var h_box_precisa: HBoxContainer = %HBoxPrecisa


func _ready() -> void:
	esconder()

func mostrar(carta: CartaRes) -> void:
	texture_comodo.texture = carta.imagem
	label_nome.text = carta.nome
	
	for c in h_box_prod.get_children(): 	c.queue_free()
	for c in h_box_precisa.get_children(): 	c.queue_free()
	
	# producao
	for recurso : GerenciadorRecursos.Recurso in carta.recurso_gerado.keys():
		h_box_prod.add_child(_cria_texture_rect(recurso))
	# precisa
	for recurso : GerenciadorRecursos.Recurso in carta.recurso_recebido.keys():
		h_box_precisa.add_child(_cria_texture_rect(recurso))
	
	show()

func esconder() -> void:
	hide()

func _cria_texture_rect(recurso : GerenciadorRecursos.Recurso) -> TextureRect:
	var imagem: Texture = RecursoImagem.get_texture_recurso(recurso)
	var texture_rect :=  TEXTURE_RECURSO.instantiate() as TextureRect
	texture_rect.texture = imagem
	return texture_rect


func _on_button_x_pressed() -> void:
	esconder()
