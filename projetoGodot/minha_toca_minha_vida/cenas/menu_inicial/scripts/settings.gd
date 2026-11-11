extends Control

const MAIN_MENU = "uid://clchghhc7g57k"

@onready var UI_SOUND = UISoundConnector

# --- SLIDERS ---
@onready var slider_master: HSlider = %SliderMaster
@onready var slider_music: HSlider = %SliderMusic
@onready var slider_ui: HSlider = %SliderUi

# --- MUTE ---
@onready var check_mute: CheckButton = %CheckMute

# --- LABELS DE PORCENTAGEM ---
@onready var por_master: Label = %porMaster
@onready var por_music: Label = %porMusic
@onready var por_ui: Label = %porUi

# --- PÁGINAS DAS ABAS ---
@onready var paginas = {
	"geral": %PaginaGeral,
	"audio": %PaginaAudio,
	"video": %PaginaVideo,
	"mobile": %PaginaMobile
}

func _ready():

	var conector = UI_SOUND.new()
	add_child(conector)
	await get_tree().process_frame
	conector.conectar_botoes(self)


	slider_master.value = Config.volume_master
	slider_music.value = Config.volume_music
	slider_ui.value = Config.volume_ui
	
	_aplicar_volumes()
	_atualizar_textos_porcentagem()
	

	_mostrar_pagina("geral")

# ============ LÓGICA DAS ABAS ============

func _mostrar_pagina(nome_pagina: String):
	for chave in paginas:
		paginas[chave].visible = (chave == nome_pagina)

func _on_btn_tab_geral_pressed(): 
	_mostrar_pagina("geral")

func _on_btn_tab_audio_pressed(): 
	_mostrar_pagina("audio")

func _on_btn_tab_video_pressed(): 
	_mostrar_pagina("video")

func _on_btn_tab_mobile_pressed(): 
	_mostrar_pagina("mobile")

func _on_btn_voltar_pressed():
	if get_tree().paused:
		get_parent().get_node("VBoxContainer").show()
		get_parent().get_node("ColorRect").show()
		get_parent().get_node("VBoxContainer/BtnSalvar").release_focus()
		get_parent().get_node("VBoxContainer/BtnSaves").release_focus()
		queue_free()
	else:
		get_tree().change_scene_to_file(MAIN_MENU)

func _unhandled_input(event):
	if event.is_action_pressed("ui_focus_next"):
		_on_btn_voltar_pressed() 
		get_viewport().set_input_as_handled()

# ============ ÁUDIO ============

func _aplicar_volumes():
	AudioServer.set_bus_volume_db(0, linear_to_db(slider_master.value))
	AudioServer.set_bus_volume_db(1, linear_to_db(slider_music.value))
	AudioServer.set_bus_volume_db(3, linear_to_db(slider_ui.value))
	

	AudioServer.set_bus_mute(0, check_mute.button_pressed)

func _atualizar_textos_porcentagem():
	por_master.text = str(int(slider_master.value * 100)) + "%"
	por_music.text = str(int(slider_music.value * 100)) + "%"
	por_ui.text = str(int(slider_ui.value * 100)) + "%"

func _on_slider_master_value_changed(value):
	Config.volume_master = value
	_aplicar_volumes()
	_atualizar_textos_porcentagem()

func _on_slider_music_value_changed(value):
	Config.volume_music = value
	_aplicar_volumes()
	_atualizar_textos_porcentagem()

func _on_slider_ui_value_changed(value):
	Config.volume_ui = value
	_aplicar_volumes()
	_atualizar_textos_porcentagem()

func _on_check_mute_toggled(toggled_on: bool):
	Config.mute = toggled_on
	_aplicar_volumes()
