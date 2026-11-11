extends Node2D

const JOGO = "uid://bq1wvhaj4qxce"

func _ready():
	# Novo jogo: limpa qualquer save carregado
	AudioManager.parar_musica()
	GameState.dados_carregados = {}
	GameState.slot_atual = -1
	GameState.vida_atual = 100
	GameState.fase_atual = "inicio"
	# Vai direto para o jogo
	get_tree().change_scene_to_file(JOGO)
