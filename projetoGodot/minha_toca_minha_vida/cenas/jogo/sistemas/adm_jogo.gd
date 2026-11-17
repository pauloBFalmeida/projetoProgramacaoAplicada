class_name AdmJogo
extends Node

signal avancou_nivel

const QTD_CARTAS_MAO : int = 5

@export_group("Nodos")
@export var adm_grafo_comodos: AdmGrafoComodos
@export var escolha_cartas: EscolhaCartas
@export var grid_comodos: GridComodos

@export_group("Resources")
@export var lista_cartas_comodos : ListaCartas
@export var carta_comodo_inicial : CartaRes

@export_group("Settings")
## Quantidade total de cartas no jogo para avancar para o nivel [br]
## Key: Ao alcancar essa quantidade, avanca para o nivel que esta no valor dessa key [br]
## Value: o nivel que sera vai virar [br]
## Exemplo: 50: 5, ao colocar a 50 carta vai comecar o nivel 5
@export var nivel_por_qtd_cartas : Dictionary[int, int] = {
	1: 		1, 
	10: 	2,
	30: 	3,
}

## Dictionary[int, Array]
var cartas_comodo_por_nivel : Dictionary = {}
## qual nivel esta atualmente
var nivel_atual : int = 0
## Quantidade total de cartas colocadas no tabuleiro
var cartas_colocadas : int = 0

var cartas_comodo_ate_niveis_atual : Array[CartaRes] = []
var sequencia_cartas_comodo : Array[CartaRes] = []

func _ready() -> void:
	escolha_cartas.carta_pega.connect(grid_comodos.mostrar_posicoes_disponiveis.unbind(1))
	escolha_cartas.carta_cancelada.connect(grid_comodos.esconder_posicoes)
	escolha_cartas.carta_colocada.connect(_on_carta_colocada)
	
	escolha_cartas.carta_pega.connect(_mostrar_recursos_comodos)
	escolha_cartas.carta_cancelada.connect(grid_comodos.esconder_recursos)
	escolha_cartas.carta_colocada.connect(grid_comodos.esconder_recursos.unbind(2))
	
	escolha_cartas.clicou_carta.connect(_mostar_info_carta)
	
	escolha_cartas.sem_cartas.connect(_on_sem_cartas)

func iniciar() -> void:
	cartas_comodo_por_nivel.clear()
	for carta_res : CartaRes in lista_cartas_comodos.cartas:
		var _nivel : int = carta_res.nivel_desbloqueio
		if not cartas_comodo_por_nivel.has(_nivel):
			var cartas_nivel: Array[CartaRes] = []
			cartas_comodo_por_nivel[_nivel] = cartas_nivel
		
		cartas_comodo_por_nivel[_nivel].append(carta_res)
	
	escolha_cartas.adicionar_carta(carta_comodo_inicial)
	
	#for i in QTD_CARTAS_MAO:
		#escolha_cartas.adicionar_carta(carta_comodo_inicial)

# Ao adicionar uma carta
# -----------------------------------------------------------------------------

func _on_carta_colocada(area: Area2D, carta: CartaRes) -> void:
	if not _posicionar_comodo(area, carta): return
	_progredir()

## Retorna se foi possivel adicionar o comodo
func _posicionar_comodo(area: Area2D, carta: CartaRes) -> bool:
	grid_comodos.esconder_posicoes()
	
	var comodo := grid_comodos.get_comodo_from_area(area)
	if not comodo or comodo.ocupado: return false
	
	adm_grafo_comodos.colocar_comodo(carta, comodo.grid_pos)
	grid_comodos.disponibilizar_vizinhos(comodo)
	
	comodo.ocupar(carta.imagem)
	return true

# Avancar de nivel
# -----------------------------------------------------------------------------

func _progredir() -> void:
	cartas_colocadas += 1
	
	if nivel_por_qtd_cartas.has(cartas_colocadas):
		_prox_nivel()

func _prox_nivel() -> void:
	nivel_atual = nivel_por_qtd_cartas[cartas_colocadas]
	
	if cartas_comodo_por_nivel.has(nivel_atual):
		_fill_cartas_ate_nivel_atual()
	
	avancou_nivel.emit()

# Sem Cartas
# -----------------------------------------------------------------------------

func _on_sem_cartas() -> void:
	for i in range(QTD_CARTAS_MAO):
		var _carta : CartaRes = cartas_comodo_ate_niveis_atual.pop_back()
		
		while not _carta:
			_fill_cartas_ate_nivel_atual()
			_carta = cartas_comodo_ate_niveis_atual.pop_back()
		
		escolha_cartas.adicionar_carta(_carta)

# Outros
# -----------------------------------------------------------------------------

func _fill_cartas_ate_nivel_atual() -> void:
	cartas_comodo_ate_niveis_atual.clear()
	for _nivel in range(1, nivel_atual+1):
		# pega as cartas do nivel como 
		cartas_comodo_ate_niveis_atual += cartas_comodo_por_nivel[_nivel]
	
	cartas_comodo_ate_niveis_atual.shuffle()

# Mostar informacoes
# -----------------------------------------------------------------------------

func _mostrar_recursos_comodos(_carta_pega: CartaRes) -> void:
	var recursos : Array[GerenciadorRecursos.Recurso] = _carta_pega.recurso_recebido.keys()
	if recursos.is_empty(): return
	
	var comodos_ocupados : Array[ComodoBase] = grid_comodos.get_comodos_ocupados()
	for comodo: ComodoBase in comodos_ocupados:
		var _pos_grid : Vector2i = comodo.grid_pos
		var _recurso_qtd : Dictionary[GerenciadorRecursos.Recurso, int] = {}
		for _recurso in recursos:
			var qtd := adm_grafo_comodos.get_quantidade(_pos_grid, _recurso)
			_recurso_qtd[_recurso] = qtd
		comodo.mostrar_recursos(_recurso_qtd)

func _mostar_info_carta(_carta: CartaRes) -> void:
	print("INFO DA CARTAAAA")
	print("nome: ", _carta.nome)
	
