## [b]Gerenciador de Recursos[/b][br]
## Gere os recursos durante o jogo
extends Node

enum Recurso {
	MORADIA,
	MOEDAS,
	LAZER,
	COMIDA,
	CONHECIMENTO,
	#PEDRA,
	#MADEIRA
}

enum Qntd {
	BAIXO,
	MEDIO,
	ALTO,
}

const qntd_para_numero := {
	Qntd.BAIXO: 2,
	Qntd.MEDIO: 3,
	Qntd.ALTO:  4,
}

var recursos_atuais : Dictionary[Recurso, int] = {}

func _ready() -> void:
	# TODO: trocar isso
	load_dados()

func load_dados() -> void:
	for recurso in Recurso.values():
		recursos_atuais[recurso] = 0
