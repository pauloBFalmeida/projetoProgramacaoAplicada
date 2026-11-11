extends CanvasLayer

@onready var fundo_escuro = $ColorRect
@onready var vbox_botoes = $VBoxContainer
@onready var save_popup: PopupPanel = %SavePopup
@onready var confirm_save: ConfirmationDialog = %ConfirmSave

var slot_pendente: int = -1

const SAVES = preload("uid://bxyr6l60euag6")
const SETTINGS = preload("uid://ovssyi1b1mwe")
const MAIN_MENU = "uid://clchghhc7g57k"

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	save_popup.process_mode = Node.PROCESS_MODE_ALWAYS
	confirm_save.process_mode = Node.PROCESS_MODE_ALWAYS
	
	if not confirm_save.confirmed.is_connected(_on_confirm_save_confirmed):
		confirm_save.confirmed.connect(_on_confirm_save_confirmed)
	if not confirm_save.canceled.is_connected(_on_confirm_save_canceled):
		confirm_save.canceled.connect(_on_confirm_save_canceled)
	
	hide()

# ============ CONTROLE GERAL ============

func abrir_menu():
	show()
	fundo_escuro.modulate = Color(1, 1, 1, 1)
	vbox_botoes.modulate = Color(1, 1, 1, 1)
	get_tree().paused = true
	
	$VBoxContainer/BtnSalvar.release_focus()
	$VBoxContainer/BtnSaves.release_focus()
	$VBoxContainer/BtnConfig.release_focus()
	$VBoxContainer/BtnSair.release_focus()

func fechar_menu():
	hide()
	get_tree().paused = false

func _fechar_popup_e_voltar():
	save_popup.hide()
	confirm_save.hide()
	fundo_escuro.modulate = Color(1, 1, 1, 1)
	vbox_botoes.modulate = Color(1, 1, 1, 1)

# ============ LÓGICA DE SALVAR ============

func _salvar_no_slot(slot: int):
	GameState.slot_atual = slot
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		SaveManager.salvar(slot, {
			"pos_x": player.position.x,
			"pos_y": player.position.y,
			"vida": GameState.vida_atual
		})
		print("Jogo salvo no slot ", slot)
	else:
		print("ERRO: Player não encontrado! Coloque o Player no grupo 'player'.")
		
	_fechar_popup_e_voltar()

# ============ FUNÇÕES DOS BOTÕES ============

func _on_btn_saves_pressed():
	$VBoxContainer.hide()
	$ColorRect.hide()
	
	var saves_scene = SAVES.instantiate()
	saves_scene.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(saves_scene)

func _on_btn_config_pressed():
	$VBoxContainer.hide()
	$ColorRect.hide()
	
	var config_scene = SETTINGS.instantiate()
	config_scene.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(config_scene)

func _on_btn_sair_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU)

func _on_btn_salvar_pressed():
	fundo_escuro.modulate = Color(1, 1, 1, 0)
	vbox_botoes.modulate = Color(1, 1, 1, 0)
	save_popup.popup_centered()

func _on_popup_slot_1_pressed():
	slot_pendente = 1
	save_popup.hide()
	confirm_save.dialog_text = "Deseja salvar no Slot 1?"
	confirm_save.popup_centered()

func _on_popup_slot_2_pressed():
	slot_pendente = 2
	save_popup.hide()
	confirm_save.dialog_text = "Deseja salvar no Slot 2?"
	confirm_save.popup_centered()

func _on_popup_slot_3_pressed():
	slot_pendente = 3
	save_popup.hide()
	confirm_save.dialog_text = "Deseja salvar no Slot 3?"
	confirm_save.popup_centered()

func _on_popup_cancelar_pressed():
	_fechar_popup_e_voltar()

func _on_confirm_save_confirmed():
	_salvar_no_slot(slot_pendente)

func _on_confirm_save_canceled():
	_fechar_popup_e_voltar()
