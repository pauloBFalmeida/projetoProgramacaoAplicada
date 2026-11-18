extends Button

const MAIN_MENU = "uid://clchghhc7g57k"

func _ready() -> void:
	pressed.connect(_on_btn_voltar_pressed)

func _on_btn_voltar_pressed():
	get_tree().change_scene_to_file(MAIN_MENU)
