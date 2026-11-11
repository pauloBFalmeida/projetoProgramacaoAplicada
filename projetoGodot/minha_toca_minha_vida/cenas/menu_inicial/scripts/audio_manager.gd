extends Node

# --- EFEITOS DE UI ---
var som_hover: AudioStream = preload("res://assets/audio/btn_hover.mp3")
var som_click: AudioStream = preload("res://assets/audio/btn_click.mp3")

var player_hover: AudioStreamPlayer
var player_click: AudioStreamPlayer

# --- MÚSICA DE FUNDO ---
var musica: AudioStream = preload("res://assets/audio/music_fundo.mp3") # ⚠️ COLOQUE O NOME DO ARQUIVO AQUI
var player_musica: AudioStreamPlayer

func _ready():
	player_hover = AudioStreamPlayer.new()
	player_click = AudioStreamPlayer.new()
	player_hover.bus = "UI"
	player_click.bus = "UI"
	add_child(player_hover)
	add_child(player_click)
	
	player_musica = AudioStreamPlayer.new()
	player_musica.bus = "Music"
	player_musica.stream = musica
	add_child(player_musica)

func tocar_hover():
	player_hover.stream = som_hover
	player_hover.play()

func tocar_click():
	player_click.stream = som_click
	player_click.play()

func tocar_musica():
	if not player_musica.playing:
		player_musica.play()

func parar_musica():
	player_musica.stop()
