extends Node
class_name AdmTutorial

@export var adm_jogo: AdmJogo

func _ready() -> void:
	adm_jogo.avancou_nivel.connect(func(x): print("AVANCOU ", x) )
	adm_jogo.terminou_jogo.connect(func(): print("FIM") )
