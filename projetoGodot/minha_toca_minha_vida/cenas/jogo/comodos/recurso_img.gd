class_name RecursoImagem
extends Sprite2D

@export var tween_duracao := 1.2
@export var tween_rot := PI/8
@export var tween_trans := Tween.TRANS_CUBIC

const ITEM_COMIDA = preload("uid://bgtcu7prmpoqv")
const ITEM_CONHECIMENTO = preload("uid://c5dwyi5wdb8ld")
const ITEM_CORACAO = preload("uid://c243uodnmib0f")
const ITEM_MOEDA = preload("uid://6yuta3imc136")
const ITEM_MORADIA = preload("uid://b17uoqljqex0o")

func set_recurso(_recurso : GerenciadorRecursos.Recurso) -> void:
	if _recurso != null:
		texture = get_texture_recurso(_recurso)
		show()
	else:
		hide()

static func get_texture_recurso(_recurso : GerenciadorRecursos.Recurso) -> Texture2D:
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


func criar_tween_delay(id: int, max_recursos: int) -> void:
	var delay := id * (tween_duracao / (max_recursos * 2))
	await get_tree().create_timer(delay).timeout
	
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(tween_trans)
	tween.tween_property(self, "rotation", -tween_rot, tween_duracao)
	tween.tween_property(self, "rotation",  tween_rot, tween_duracao)
	tween.set_loops()
