class_name AdmJogo
extends Node

@export var adm_grafo_comodos: AdmGrafoComodos
@export var escolha_cartas: EscolhaCartas
@export var grid_comodos: GridComodos

@export var lista_cartas_comodos : ListaCartas

@export var carta_comodo_inicial : CartaRes

var cartas_comodo_por_nivel : Dictionary[int, Array] = {}

var nivel_atual := 1

func iniciar() -> void:
	# prepara as cartas
	for carta_res : CartaRes in lista_cartas_comodos.cartas:
		var nivel := carta_res.nivel_desbloqueio
		if not cartas_comodo_por_nivel.has(nivel):
			cartas_comodo_por_nivel[nivel] = []
		cartas_comodo_por_nivel[nivel].append(carta_res)
	
	escolha_cartas.carta_colocada.connect(_on_carta_colocada)
	
	escolha_cartas.adicionar_carta(carta_comodo_inicial)
	grid_comodos.liberar_comodo(Vector2i(2,0))
	grid_comodos.set_piscar_comodos(true)
	#for carta_res : CartaRes in cartas_comodo_por_nivel[nivel_atual]:
		#escolha_cartas.adicionar_carta(carta_res)

func _on_carta_colocada(area: Area2D, carta: CartaRes) -> void:
	grid_comodos.bloquear_comodo_area(area)
	grid_comodos.liberar_comodo(Vector2i(2,1))
	grid_comodos.liberar_comodo(Vector2i(1,0))
	grid_comodos.liberar_comodo(Vector2i(3,0))
	#grid_comodos.set_piscar_comodos(true)
	
