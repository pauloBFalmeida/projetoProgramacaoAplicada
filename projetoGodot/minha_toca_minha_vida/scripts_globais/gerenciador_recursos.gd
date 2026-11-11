extends Node

enum Recurso {
	MORADIA,
	MOEDAS,
	LAZER,
	COMIDA,
	PEDRA,
	MADEIRA
}
var dinheiro : int = 10
var recursos_atuais : Dictionary[Recurso, int] = {}

func _ready() -> void:
	# TODO: trocar isso
	load_dados()

func load_dados() -> void:
	for recurso in Recurso.values():
		recursos_atuais[recurso] = 0


var dinheiro_sum = 10
func add_dinheiro(geracao_dinheiro_seg: float) -> void:
	dinheiro_sum += geracao_dinheiro_seg

func rem_dinheiro(custo) -> void:
	dinheiro_sum -= custo

func _physics_process(delta: float) -> void:
	dinheiro = int(dinheiro_sum)
