extends CanvasLayer

var _overlay: ColorRect

func _ready():
	layer = 100
	_overlay = ColorRect.new()
	_overlay.color = Color(1, 1, 1, 1)
	_overlay.anchors_preset = Control.PRESET_FULL_RECT
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_overlay.material = CanvasItemMaterial.new()
	_overlay.material.blend_mode = CanvasItemMaterial.BLEND_MODE_MUL
	add_child(_overlay)

func definir_brilho(valor: float):
	# valor de 0.3 (escuro) a 1.0 (normal)
	_overlay.color = Color(valor, valor, valor, 1.0)
