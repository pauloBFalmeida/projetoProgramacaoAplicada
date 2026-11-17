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
	5: 		2,
	10: 	3,
}

var cartas_comodo_por_nivel : Dictionary[int, Array] = {}
## qual nivel esta atualmente
var nivel_atual : int = 0
## Quantidade total de cartas colocadas no tabuleiro
var cartas_colocadas : int = 0

func _ready() -> void:
	escolha_cartas.carta_pega.connect(grid_comodos.mostrar_posicoes_disponiveis)
	escolha_cartas.carta_cancelada.connect(grid_comodos.esconder_posicoes)
	escolha_cartas.carta_colocada.connect(_on_carta_colocada)
	
	escolha_cartas.sem_cartas.connect(_on_sem_cartas)

func iniciar() -> void:
	cartas_comodo_por_nivel.clear()
	for carta_res : CartaRes in lista_cartas_comodos.cartas:
		cartas_comodo_por_nivel.get_or_add(carta_res.nivel_desbloqueio, []).append(carta_res)
	
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
	
	avancou_nivel.emit()

# Sem Cartas
# -----------------------------------------------------------------------------

func _on_sem_cartas() -> void:
	for i in range(10):
		escolha_cartas.adicionar_carta(carta_comodo_inicial)
