extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_temp_set_point_value_changed(temp_set_point: float) -> void:
	text = str(temp_set_point)
	$ErrorLabel.text = "-99"
