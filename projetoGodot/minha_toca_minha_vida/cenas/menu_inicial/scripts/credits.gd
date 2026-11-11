extends Control

@onready var UI_SOUND = UISoundConnector

const MAIN_MENU = "uid://clchghhc7g57k"

func _ready():
	var conector = UI_SOUND.new()
	add_child(conector)
	await get_tree().process_frame
	conector.conectar_botoes(self)

func _on_btn_voltar_pressed():
	get_tree().change_scene_to_file(MAIN_MENU)

#func _on_link_paulo_pressed():
	#OS.shell_open("https://www.youtube.com/watch?v=RAbkGifbby0&list=RDRAbkGifbby0&start_radio=1")
#
#func _on_link_julia_pressed():
	#OS.shell_open("https://portfolio-da-julia.com")
#
#func _on_link_diogo_pressed():
	#OS.shell_open("https://portfolio-do-diogo.com")
