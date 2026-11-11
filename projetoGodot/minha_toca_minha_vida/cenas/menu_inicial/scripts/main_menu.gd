extends Control

const SAVES = "uid://bxyr6l60euag6"
const NOVO_JOGO = "uid://2i8sl6pxh0do"
const SETTINGS = "uid://ovssyi1b1mwe"
const CREDITS = "uid://dm7k0lt1xsmp5"

@onready var UI_SOUND = UISoundConnector

func _ready():
	AudioManager.tocar_musica()
	var conector = UI_SOUND.new()
	add_child(conector)
	await get_tree().process_frame
	conector.conectar_botoes(self)
	if GameState.abrir_saves_ao_iniciar:
		GameState.abrir_saves_ao_iniciar = false # Reseta a variável
		get_tree().change_scene_to_file(SAVES)
	DisplayServer.screen_set_keep_on(Config.keep_screen_on)

func _on_btn_iniciar_pressed():
	get_tree().change_scene_to_file(NOVO_JOGO)

func _on_btn_saves_pressed():
	get_tree().change_scene_to_file(SAVES)

func _on_btn_settings_pressed():
	get_tree().change_scene_to_file(SETTINGS)

func _on_btn_credits_pressed():
	get_tree().change_scene_to_file(CREDITS)

func _on_btn_quit_pressed():
	get_tree().quit()
