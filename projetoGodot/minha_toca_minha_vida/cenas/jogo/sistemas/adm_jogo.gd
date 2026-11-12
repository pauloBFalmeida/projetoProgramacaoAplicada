class_name AdmJogo
extends Node

@export var adm_grafo_comodos: AdmGrafoComodos
@export var escolha_cartas: EscolhaCartas
@export var grid_comodos: GridComodos

@export var lista_cartas_comodos : ListaCartas

@export var carta_comodo_inicial : CartaRes

var cartas_comodo_por_nivel : Dictionary[int, Array] = {}

var nivel_atual := 1

func _ready() -> void:
	escolha_cartas.carta_pega.connect(_on_carta_pega)
	escolha_cartas.carta_cancelada.connect(_parar_piscar_comodos)
	
	escolha_cartas.carta_colocada.connect(_on_carta_colocada)
	

func iniciar() -> void:
	# prepara as cartas
	for carta_res : CartaRes in lista_cartas_comodos.cartas:
		var nivel := carta_res.nivel_desbloqueio
		if not cartas_comodo_por_nivel.has(nivel):
			cartas_comodo_por_nivel[nivel] = []
		cartas_comodo_por_nivel[nivel].append(carta_res)
		
	escolha_cartas.adicionar_carta(carta_comodo_inicial)
	escolha_cartas.adicionar_carta(carta_comodo_inicial)
	escolha_cartas.adicionar_carta(carta_comodo_inicial)
	escolha_cartas.adicionar_carta(carta_comodo_inicial)
	grid_comodos.liberar_comodo(Vector2i(2,0))

func _on_carta_colocada(area: Area2D, carta: CartaRes) -> void:
	var comodo : ComodoBase = grid_comodos.get_comodo_from_area(area)
	if not comodo: return
	
	# coloca no grafo
	var pos_grid: Vector2i = grid_comodos.get_grid_pos_from_comodo(comodo)
	adm_grafo_comodos.colocar_comodo(carta, pos_grid)
	# ajusta a imagem
	var textura: Texture2D = carta.imagem
	comodo.set_textura_comodo(textura)
	# mostra o comodo
	comodo.mostrar_comodo()
	
	# bloqueia a area para nao colocar outros comodos
	grid_comodos.bloquear_comodo(pos_grid)
	# liberar comodos ao redor
	grid_comodos.liberar_redor_comodo(pos_grid)
	
	_parar_piscar_comodos()

func _on_carta_pega() -> void:
	grid_comodos.set_piscar_comodos(true)

func _parar_piscar_comodos() -> void:
	grid_comodos.set_piscar_comodos(false)
