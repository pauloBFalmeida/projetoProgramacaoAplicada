extends Control

@onready var h_box: HBoxContainer = $HBox

func _ready() -> void:
	for c in h_box.get_children():
		var comodo := c as ButtonComodo
		comodo.pressed.connect(_desativar_outros.bind(comodo))

func _desativar_outros(comodo_ativado : ButtonComodo) -> void:
	for c in h_box.get_children():
		var comodo := c as ButtonComodo
		if comodo != comodo_ativado:
			comodo.desclicado()
