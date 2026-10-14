extends Node

enum Recurso {
	MORADIA,
	MOEDAS,
	LAZER,
	COMIDA,
	PEDRA,
	MADEIRA
}

var recursos_atuais : Dictionary[Recurso, int] = {}

func _ready() -> void:
	# TODO: trocar isso
	load_dados()

func load_dados() -> void:
	for recurso in Recurso.values():
		recursos_atuais[recurso] = 0
