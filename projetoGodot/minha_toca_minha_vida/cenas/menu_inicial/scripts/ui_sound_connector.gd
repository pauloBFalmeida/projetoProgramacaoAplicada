class_name UISoundConnector
extends Node

func conectar_botoes(node_raiz: Node) -> void:
	for filho in node_raiz.get_children():
		if filho is BaseButton:
			if not filho.mouse_entered.is_connected(_on_hover):
				filho.mouse_entered.connect(_on_hover)
			if not filho.pressed.is_connected(_on_click):
				filho.pressed.connect(_on_click)
		conectar_botoes(filho)

func _on_hover():
	if AudioManager:
		AudioManager.tocar_hover()

func _on_click():
	if AudioManager:
		AudioManager.tocar_click()
