extends Control

const JOGO = "uid://bq1wvhaj4qxce"
const MAIN_MENU = "uid://clchghhc7g57k"

@onready var UI_SOUND = UISoundConnector

@onready var btn_slot1: Button = $Slots/Slot1/btnslot1
@onready var btn_slot2: Button = $Slots/Slot2/btnslot2
@onready var btn_slot3: Button = $Slots/Slot3/btnslot3
@onready var confirm_delete: ConfirmationDialog = %ConfirmDelete

var slot_pendente_delete: int = -1

func _ready():
	var conector = UI_SOUND.new()
	add_child(conector)
	await get_tree().process_frame
	conector.conectar_botoes(self)
	
	
	_atualizar_slots()

func _unhandled_input(event):
	if event.is_action_pressed("ui_focus_next"): # Se apertar TAB
		_on_btn_voltar_pressed() 
		get_viewport().set_input_as_handled()

# ============ ATUALIZAR INTERFACE ============

func _atualizar_slots():
	btn_slot1.text = SaveManager.info_slot(1)
	btn_slot2.text = SaveManager.info_slot(2)
	btn_slot3.text = SaveManager.info_slot(3)

# ============ USAR UM SLOT ============

func _on_btnslot_1_pressed(): _usar_slot(1)
func _on_btnslot_2_pressed(): _usar_slot(2)
func _on_btnslot_3_pressed(): _usar_slot(3)

func _usar_slot(slot: int):
	GameState.slot_atual = slot
	
	if SaveManager.slot_existe(slot):
		GameState.dados_carregados = SaveManager.carregar(slot)
		print("Carregando save do slot ", slot)
	else:
		GameState.dados_carregados = {}
		SaveManager.salvar(slot, {
			"vida": 100,
			"fase": "inicio",
			"pos_x": 480,
			"pos_y": 900
		})
		print("Novo jogo criado no slot ", slot)
	
	get_tree().change_scene_to_file(JOGO)

# ============ APAGAR UM SLOT ============

func _on_btndelete_1_pressed(): _pedir_confirmacao_delete(1)
func _on_btndelete_2_pressed(): _pedir_confirmacao_delete(2)
func _on_btndelete_3_pressed(): _pedir_confirmacao_delete(3)

func _pedir_confirmacao_delete(slot: int):
	slot_pendente_delete = slot
	confirm_delete.dialog_text = "Tem certeza que deseja apagar o Slot %d?" % slot
	confirm_delete.popup_centered() 

func _on_confirm_delete_confirmed():
	SaveManager.apagar(slot_pendente_delete)
	_atualizar_slots() 

# ============ NAVEGAÇÃO ============

func _on_btn_voltar_pressed():
	if get_tree().paused:
		get_parent().get_node("VBoxContainer").show()
		get_parent().get_node("ColorRect").show()
		get_parent().get_node("VBoxContainer/BtnSalvar").release_focus()
		get_parent().get_node("VBoxContainer/BtnSaves").release_focus()
		queue_free()
	else:
		get_tree().change_scene_to_file(MAIN_MENU)
