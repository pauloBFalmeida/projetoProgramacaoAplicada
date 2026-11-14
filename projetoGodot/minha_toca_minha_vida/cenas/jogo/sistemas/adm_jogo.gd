class_name AdmJogo
extends Node

const QTD_CARTAS_MAO : int = 5

@export var adm_grafo_comodos: AdmGrafoComodos
@export var escolha_cartas: EscolhaCartas
@export var grid_comodos: GridComodos

@export var lista_cartas_comodos : ListaCartas
@export var carta_comodo_inicial : CartaRes

var cartas_comodo_por_nivel : Dictionary[int, Array] = {}
var nivel_atual : int = 1

func _ready() -> void:
	escolha_cartas.carta_pega.connect(grid_comodos.mostrar_posicoes_disponiveis)
	escolha_cartas.carta_cancelada.connect(grid_comodos.esconder_posicoes)
	escolha_cartas.carta_colocada.connect(_on_carta_colocada)

func iniciar() -> void:
	cartas_comodo_por_nivel.clear()
	for carta_res : CartaRes in lista_cartas_comodos.cartas:
		cartas_comodo_por_nivel.get_or_add(carta_res.nivel_desbloqueio, []).append(carta_res)
	
	escolha_cartas.adicionar_carta(carta_comodo_inicial)
	
	#for i in QTD_CARTAS_MAO:
		#escolha_cartas.adicionar_carta(carta_comodo_inicial)

func _on_carta_colocada(area: Area2D, carta: CartaRes) -> void:
	grid_comodos.esconder_posicoes()
	
	var comodo := grid_comodos.get_comodo_from_area(area)
	if not comodo or comodo.ocupado: return
	
	adm_grafo_comodos.colocar_comodo(carta, comodo.grid_pos)
	grid_comodos.disponibilizar_vizinhos(comodo)
	
	comodo.ocupar(carta.imagem)
