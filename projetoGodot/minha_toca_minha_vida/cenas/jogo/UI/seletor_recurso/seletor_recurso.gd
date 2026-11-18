class_name SeletorRecurso
extends Control

signal mostrar_recurso(recurso: GerenciadorRecursos.Recurso)
signal esconder_recurso

const BUTTON_RECURSO = preload("uid://ddtaxl2d4lovp")

@onready var v_box_container: VBoxContainer = %VBoxContainer

var recursos_por_botao : Dictionary[Button, GerenciadorRecursos.Recurso] = {}

func _ready() -> void:
	for c in v_box_container.get_children(): c.queue_free()
	
	for recurso in GerenciadorRecursos.Recurso.values():
		var btn := BUTTON_RECURSO.instantiate() as Button
		btn.icon = RecursoImagem.get_texture_recurso(recurso)
		btn.toggled.connect(_btn_toggled.bind(btn))
		
		recursos_por_botao[btn] = recurso
		v_box_container.add_child(btn)

func _btn_toggled(_on: bool, btn: Button) -> void:
	var recurso := recursos_por_botao[btn]
	
	# botao ligado
	if _on:
		# desliga outros
		for b : Button in recursos_por_botao.keys():
			if b != btn and b.button_pressed:
				_btn_toggled(false, b)
		# mostra o recurso
		mostrar_recurso.emit(recurso)
	# botao desligado
	else:
		btn.button_pressed = false
		esconder_recurso.emit()
