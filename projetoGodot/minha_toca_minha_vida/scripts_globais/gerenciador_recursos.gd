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


# Get Valor de Recurso
# -----------------------------------------------------------------------------

func get_valor_recurso_recebido(_recurso: Recurso, _qtde: Qntd) -> int:
	var _valor := _get_valor_recurso(_recurso, _qtde)
	return _valor - 1

func get_valor_recurso_gerado(_recurso: Recurso, _qtde: Qntd) -> int:
	return _get_valor_recurso(_recurso, _qtde)
	
func _get_valor_recurso(_recurso: Recurso, _qtde: Qntd) -> int:
	return qntd_para_numero.get(_qtde, 0)
