extends Node2D

@onready var UI_SOUND = UISoundConnector

@onready var player: ColorRect = %Player

var velocidade: float = 600.0

func _ready():
	AudioManager.parar_musica()
	var conector = UI_SOUND.new()
	add_child(conector)
	await get_tree().process_frame
	conector.conectar_botoes(self)
	
	if not GameState.dados_carregados.is_empty():
		var dados = GameState.dados_carregados
		player.position = Vector2(dados.get("pos_x", 480), dados.get("pos_y", 900))
		print("Save carregado: ", dados)
		GameState.dados_carregados = {}
	else:
		player.position = Vector2(480, 900)
		print("Novo jogo")

func _process(delta):
	var direcao = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):  direcao.x += 1
	if Input.is_action_pressed("ui_left"):   direcao.x -= 1
	if Input.is_action_pressed("ui_down"):   direcao.y += 1
	if Input.is_action_pressed("ui_up"):     direcao.y -= 1
	
	if direcao != Vector2.ZERO:
		player.position += direcao.normalized() * velocidade * delta

# ============ PAUSE MENU ============

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_TAB:
		if get_tree().paused:
			$PauseMenu.fechar_menu()
		else:
			$PauseMenu.abrir_menu()
		get_viewport().set_input_as_handled()
