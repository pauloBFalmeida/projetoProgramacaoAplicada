class_name AdmJogo
extends Node

@export var adm_grafo_comodos: AdmGrafoComodos
@export var escolha_cartas: EscolhaCartas
@export var grid_comodos: GridComodos

@export var lista_cartas_comodos : ListaCartas

@export var carta_comodo_inicial : CartaRes

var cartas_comodo_por_nivel : Dictionary[int, Array] = {}

var nivel_atual := 1

var cartas_colocadas = []

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

func _pegar_pos(area: Area2D) -> Vector2i:
	return grid_comodos.get_grid_pos(grid_comodos.pegar_comodo(area))

func liberar_lado(pos: Vector2i) -> void:
	for p in [
		pos + Vector2i.UP,
		pos + Vector2i.DOWN,
		pos + Vector2i.LEFT,
		pos + Vector2i.RIGHT,
	]:
		grid_comodos.liberar_comodo(p)
		
@onready var label_end: Label = $"../UI/LabelEnd"

func _on_carta_colocada(area: Area2D, carta: CartaRes) -> void:
	grid_comodos.bloquear_comodo_area(area)
	
	var pos:= _pegar_pos(area)
	cartas_colocadas.append(pos)
	liberar_lado(pos)
	
	if escolha_cartas.cartas_button_lista.size() <= 1:
		for i in range(3):
			var carta_new = lista_cartas_comodos.cartas.pick_random()
			escolha_cartas.adicionar_carta(carta_new)
	#grid_comodos.liberar_comodo(Vector2i(2,1))
	#grid_comodos.liberar_comodo(Vector2i(1,0))
	#grid_comodos.liberar_comodo(Vector2i(3,0))
	#grid_comodos.set_piscar_comodos(true)
	
	if cartas_colocadas.size() >= grid_comodos.max_x * grid_comodos.max_y:
		label_end.show()

@onready var label_dinheiro: Label = %LabelDinheiro

func _physics_process(delta: float) -> void:
	label_dinheiro.text = str(GerenciadorRecursos.dinheiro)
