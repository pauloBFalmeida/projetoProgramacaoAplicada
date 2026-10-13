extends Control

@onready var h_box: HBoxContainer = $HBox

var cartas_comodos_lista : Array[ButtonComodo] = []

func _ready() -> void:
	for c in h_box.get_children():
		var comodo := c as ButtonComodo
		cartas_comodos_lista.append(c)
		comodo.pressed.connect(_pegar_carta.bind(comodo))

func _pegar_carta(comodo_pego : ButtonComodo) -> void:
	var textura := comodo_pego.get_textura_comodo()
	
	
	# mostra todos os comodos
	for comodo : ButtonComodo in cartas_comodos_lista:
		comodo.show()
	
	if comodo_pego:
		comodo_pego.hide()
		_criar_carta_pega(textura)

func _on_h_box_gui_input(event: InputEvent) -> void:
	if (
		(event is InputEventMouseButton and event.is_pressed()) or
		(event is InputEventScreenTouch and event.is_pressed())
	):
		print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		#_pegar_carta(null)


@export var mundo: Node2D
const COMODO_PEGO = preload("uid://xsse3gj2oavy")

func _criar_carta_pega(textura: Texture) -> void:
	var carta := COMODO_PEGO.instantiate() as ComodoPego
	mundo.add_child(carta)
	carta.set_textura(textura)
	carta.solto_em_area.connect(_on_solto_em_area)
	carta.solto_fora.connect(_on_solto_fora)
	carta.iniciar_arraste()

func _on_solto_em_area(area: Area2D) -> void:
	print("colocado em ", area.name)

func _on_solto_fora() -> void:
	print("fora ")
