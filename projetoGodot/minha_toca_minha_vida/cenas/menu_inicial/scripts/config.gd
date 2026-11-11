extends Node

# Valores padrão das configurações
var volume_master: float = 1.0
var volume_music: float = 1.0
var volume_ui: float = 1.0
var brightness: float = 1.0
var keep_screen_on: bool = false
var vibration: bool = true
var mute: bool = false

# Salva as configurações em arquivo
func salvar():
	var f = FileAccess.open("user://config.save", FileAccess.WRITE)
	if f:
		f.store_var({
			"volume_master": volume_master,
			"volume_music": volume_music,
			"volume_ui": volume_ui,
			"brightness": brightness,
			"keep_screen_on": keep_screen_on,
			"vibration": vibration
		})
		f.close()

# Carrega as configurações salvas
func carregar():
	if not FileAccess.file_exists("user://config.save"):
		return
	var f = FileAccess.open("user://config.save", FileAccess.READ)
	if f:
		var dados = f.get_var()
		volume_master = dados.get("volume_master", 1.0)
		volume_music = dados.get("volume_music", 1.0)
		volume_ui = dados.get("volume_ui", 1.0)
		brightness = dados.get("brightness", 1.0)
		keep_screen_on = dados.get("keep_screen_on", false)
		vibration = dados.get("vibration", true)
		f.close()
func _ready():
	carregar()
