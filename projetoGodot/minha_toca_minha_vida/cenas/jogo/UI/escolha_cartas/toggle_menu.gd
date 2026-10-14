extends Control

@export var escolha_cartas: Control

@export var base: Control
@onready var color_rect: ColorRect = $ColorRect

@onready var label_toggle_menu: Label = %LabelToggleMenu

var menu_up : bool = true

func _on_button_toggle_menu_pressed() -> void:
	var tween := create_tween()
	const duracao := 0.7
	
	if menu_up:
		var qtd_descer : float = base.global_position.y - color_rect.global_position.y
		tween.tween_property(
			escolha_cartas, "position:y",
			qtd_descer,
			duracao
		).from_current()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_EXPO)
		# troca o texto
		await tween.finished
		label_toggle_menu.text = "/\\"
	else:
		tween.tween_property(
			escolha_cartas, "position:y",
			0,
			duracao
		).from_current()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_EXPO)
		await tween.finished
		# troca o texto
		label_toggle_menu.text = "\\/"
	menu_up = not menu_up
