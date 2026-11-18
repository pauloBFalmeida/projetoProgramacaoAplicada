extends Node
class_name AdmTutorial

@export var adm_jogo: AdmJogo

const TL_INTRO := "timeline_intro"
const TL_LV_1 := "timeline_nivel_1"
const TL_LV_2 := "timeline_nivel_2"
const TL_LV_3 := "timeline_nivel_3"
const TL_FIM := "timeline_fim"
const TL_FINAL_DEMO := "timeline_final_demo"


func _ready() -> void:
	adm_jogo.avancou_nivel.connect(_avanco_nivel)
	adm_jogo.liberou_final.connect(_liberou_final)
	adm_jogo.terminou_jogo.connect(_terminou_jogo)
	
	inicio()

func inicio() -> void:
	
	if Dialogic.current_timeline != null:
		return

	Dialogic.start(TL_INTRO)

func _avanco_nivel(novo_nivel: int) -> void:
	match novo_nivel:
		1:
			Dialogic.start(TL_LV_1)
		2:
			Dialogic.start(TL_LV_2)
		3:
			Dialogic.start(TL_LV_3)
		#4:
			#Dialogic.start(TL_FIM)

func _liberou_final() -> void:
	Dialogic.start(TL_FIM)

func _terminou_jogo() -> void:
	Dialogic.start(TL_FINAL_DEMO)
