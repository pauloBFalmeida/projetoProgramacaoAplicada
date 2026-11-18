extends Node2D
class_name ComodoBase

@onready var sprite_borda: Sprite2D = $SpriteBorda
@onready var sprite_comodo: Sprite2D = $SpriteComodo
@onready var area_2d: Area2D = $Area2D

const distancia_recursos := Vector2(45.0, 50.0)
const RECURSO_IMG = preload("uid://bsfhhtfs31n3y")
const MAX_RECURSOS := 4

var pai_recursos : Node2D
var recursos_imgs_por_linha : Dictionary[int, Array]

var grid_pos : Vector2i
var ocupado : bool = false
var disponivel : bool = false

var tween_piscar : Tween

func _ready() -> void:
	esconder()
	_criar_recursos()
	#name = "ComodoBase(%d, %d)" % [grid_pos.x, grid_pos.y]

## Mostra a borda piscando (posicao disponivel para receber um comodo)
func piscar_clicavel() -> void:	
	_parar_tween()
	area_2d.monitorable = true
	
	sprite_comodo.hide()
	sprite_borda.show()
	
	sprite_borda.modulate.a = 0.2
	tween_piscar = create_tween()
	tween_piscar.set_loops()
	tween_piscar.set_ease(Tween.EASE_IN_OUT)
	tween_piscar.set_trans(Tween.TRANS_QUAD)
	tween_piscar.tween_property(sprite_borda, "modulate:a", 0.4, 1.5)
	tween_piscar.tween_property(sprite_borda, "modulate:a", 0.1, 1.5)

func esconder() -> void:
	_parar_tween()
	area_2d.monitorable = false
	sprite_comodo.hide()
	sprite_borda.hide()

## Coloca o comodo definitivamente nesta posicao
func ocupar(textura: Texture2D) -> void:
	ocupado = true
	disponivel = false
	
	_parar_tween()
	area_2d.monitorable = false
	sprite_comodo.texture = textura
	sprite_comodo.show()
	sprite_borda.show()
	sprite_borda.modulate.a = 1.0

func _parar_tween() -> void:
	if tween_piscar and tween_piscar.is_valid():
		tween_piscar.kill()

# -----------------------------------------------------------------------------
func _criar_recursos() -> void:
	pai_recursos = Node2D.new()
	add_child(pai_recursos)
	pai_recursos.hide()
	
	recursos_imgs_por_linha = {
		0: [],
		1: []
	}
	
	for y in [-1,1]:
		for x in range(MAX_RECURSOS):
			var _recurso := RECURSO_IMG.instantiate() as RecursoImagem
			pai_recursos.add_child(_recurso)
			_recurso.criar_tween_delay(x, MAX_RECURSOS)
			_recurso.position.y = y * distancia_recursos.y/2
			_recurso.position.x = (x - 1.5) * distancia_recursos.x 
			#
			var linha = 0 if y == -1 else 1
			recursos_imgs_por_linha[linha].append(_recurso)

func esconder_recursos() -> void:
	pai_recursos.hide()

func mostrar_recursos(recursos_qtd: Dictionary[GerenciadorRecursos.Recurso, int]) -> void:
	# esconde todos os filhos, ja que ao ajustar a textura mostra somente os que tem textura
	for c in pai_recursos.get_children(): c.hide()
	
	var recursos : Array[GerenciadorRecursos.Recurso] = recursos_qtd.keys()
	
	var tamanho : int = min(recursos.size(), 2)
	
	for linha in range(tamanho): # 0, 1
		var _recurso : GerenciadorRecursos.Recurso = recursos.get(linha)
		var _qtde : int = recursos_qtd.get(_recurso, 0)
		
		_qtde = min(_qtde, MAX_RECURSOS) # limite max
		# ajusta a quantidade de recusos
		for i in range(_qtde):
			var _recurso_img = recursos_imgs_por_linha[linha].get(i)
			_recurso_img.set_recurso(_recurso)
	
	pai_recursos.show()
