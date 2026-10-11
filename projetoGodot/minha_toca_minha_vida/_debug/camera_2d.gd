extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mov := Input.get_axis("ui_up", "ui_down")
	position.y += mov * delta * 200
	
	if position.y < limit_top: position.y = limit_top
	
	var limit_right_zoom = limit_right - (1280 / zoom.x)
	
	if position.x < limit_left: 
		print("LEFT")
		position.x = limit_left
	elif position.x > limit_right_zoom: 
		print("RIGHT")
		position.x = limit_right_zoom
