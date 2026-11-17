class_name RecursoImagem
extends Sprite2D

const ITEM_COMIDA = preload("uid://bgtcu7prmpoqv")
const ITEM_CONHECIMENTO = preload("uid://c5dwyi5wdb8ld")
const ITEM_CORACAO = preload("uid://c243uodnmib0f")
const ITEM_MOEDA = preload("uid://6yuta3imc136")
const ITEM_MORADIA = preload("uid://b17uoqljqex0o")

func set_recurso(_recurso : GerenciadorRecursos.Recurso) -> void:
	if _recurso != null:
		texture = _get_texture_recurso(_recurso)
		show()
	else:
		hide()

func _get_texture_recurso(_recurso : GerenciadorRecursos.Recurso) -> Texture2D:
	match _recurso:
		GerenciadorRecursos.Recurso.MORADIA:
			return ITEM_MORADIA
		GerenciadorRecursos.Recurso.MOEDAS:
			return ITEM_MOEDA
		GerenciadorRecursos.Recurso.LAZER:
			return ITEM_CORACAO
		GerenciadorRecursos.Recurso.COMIDA:
			return ITEM_COMIDA
		GerenciadorRecursos.Recurso.CONHECIMENTO:
			return ITEM_CONHECIMENTO
	return null
