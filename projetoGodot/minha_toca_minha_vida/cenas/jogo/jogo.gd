class_name Jogo
extends Node

@onready var background: Background = $Mundo/Background
@onready var camera_2d: Camera2D = $Mundo/Camera2D

@onready var adm_grafo_comodos: AdmGrafoComodos = $AdmGrafoComodos
@onready var adm_jogo: AdmJogo = $AdmJogo

@onready var escolha_cartas: EscolhaCartas = $UI/MenuCartas/EscolhaCartas
@onready var grid_comodos: GridComodos = $Mundo/GridComodos

const LISTA_CARTAS_COMODOS = preload("uid://de8vnfhq31gcq")

func _process(delta: float) -> void:
	background.aumentar_ate_cam(camera_2d.global_position)

func _ready() -> void:
	adm_jogo.iniciar()
