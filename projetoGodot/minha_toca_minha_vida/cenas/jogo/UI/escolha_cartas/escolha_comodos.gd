class_name EscolhaCartas
extends Control

signal carta_colocada(area: Area2D, carta: CartaRes)

@export var mundo: Node2D

@onready var h_box_cartas: HBoxContainer = %HBoxCartas

var cartas_button_lista : Array[CartaButton] = []
var carta_button_por_carta_pega : Dictionary[CartaSegurada, CartaButton] = {}

const COMODO_PEGO = preload("uid://xsse3gj2oavy")
const CARTA_BUTTON = preload("uid://bt4hb2p4wi1so")

const COMODO_LOJA = preload("uid://c51vlos7jb14t")
const COMODO_QUARTO = preload("uid://b8knkgyshgpca")

func _ready() -> void:
	for i in range(10):
		for carta_res in [COMODO_LOJA, COMODO_QUARTO, COMODO_LOJA, COMODO_QUARTO]:
			adicionar_carta(carta_res)

func adicionar_carta(carta_res: CartaRes) -> void:
	var carta_button := CARTA_BUTTON.instantiate() as CartaButton
	cartas_button_lista.append(carta_button)
	h_box_cartas.add_child(carta_button)
	
	carta_button.set_carta_res(carta_res)
	carta_button.pressed.connect(_pegar_carta.bind(carta_button))

func _pegar_carta(carta_button_clicada : CartaButton) -> void:
	# mostra todos os comodos
	for carta_button : CartaButton in cartas_button_lista:
		carta_button.show()
	
	if carta_button_clicada:
		carta_button_clicada.hide()
		_criar_carta_pega(carta_button_clicada)

func _on_h_box_gui_input(event: InputEvent) -> void:
	if (
		(event is InputEventMouseButton and event.is_pressed()) or
		(event is InputEventScreenTouch and event.is_pressed())
	):
		pass



func _criar_carta_pega(carta_button : CartaButton) -> void:
	var textura := carta_button.get_textura_comodo()
	
	var carta_segurada := COMODO_PEGO.instantiate() as CartaSegurada
	carta_button_por_carta_pega[carta_segurada] = carta_button
	mundo.add_child(carta_segurada)
	carta_segurada.set_textura(textura)
	carta_segurada.solto_em_area.connect(_on_solto_em_area.bind(carta_segurada))
	carta_segurada.solto_fora.connect(_on_solto_fora.bind(carta_segurada))
	carta_segurada.iniciar_arraste()

func _on_solto_em_area(area: Area2D, carta_segurada: CartaSegurada) -> void:
	if not carta_button_por_carta_pega.has(carta_segurada): return
	
	# pega a carta button
	var carta_button := carta_button_por_carta_pega[carta_segurada]
	# emite que colocou a carta na posicao, e envia o comodo referente
	carta_colocada.emit(area, carta_button.get_carta())
	
	# deleta a carta button, ja que deu certo colocar
	carta_button_por_carta_pega.erase(carta_segurada)
	cartas_button_lista.erase(carta_button)
	carta_button.queue_free()
	
	# deleta a carta segurada
	carta_segurada.queue_free()

func _on_solto_fora(carta_segurada: CartaSegurada) -> void:
	# mostra a carta novamente
	var carta_button := carta_button_por_carta_pega[carta_segurada]
	carta_button.show()
	
	# deleta a carta segurada
	carta_segurada.queue_free()
	
	print("Fora de posicao possivel")
