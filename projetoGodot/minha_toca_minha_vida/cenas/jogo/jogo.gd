class_name Jogo
extends Node

@onready var background: Background = $Mundo/Background
@onready var camera_2d: Camera2D = $Mundo/Camera2D

@onready var escolha_cartas: EscolhaCartas = $UI/MenuCartas/EscolhaCartas
@onready var grid_comodos: GridComodos = $Mundo/GridComodos

func _process(delta: float) -> void:
	background.aumentar_ate_cam(camera_2d.global_position)

func _ready() -> void:
	escolha_cartas.carta_colocada.connect(_on_carta_colocada)


func _on_carta_colocada(area: Area2D, carta: CartaRes) -> void:
	var comodo : ComodoBase = grid_comodos.pegar_comodo(area)
	
	if comodo:
		var textura: Texture2D = carta.imagem
		comodo.set_textura_comodo(textura)
		comodo.mostrar_comodo()
