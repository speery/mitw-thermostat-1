extends Node2D

var graph_left: int = 45
var graph_right: int = 700
var graph_height: int = 150
var graph_margin: int = 4
var below_zero: int = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	$TopLine.add_point(Vector2(graph_left, 0))
	$TopLine.add_point(Vector2(graph_right,0))
	$BottomLine.add_point(Vector2(graph_left, graph_height + (graph_margin * 2)))
	$BottomLine.add_point(Vector2(graph_right, graph_height + (graph_margin * 2)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func set_data_frame(inside: float, outside: float, thermostat: float) -> void:
	set_line_frame($InsideTemperature, inside)
	set_line_frame($OutsideTemperature, outside)
	set_line_frame($Thermostat, thermostat)

func set_line_frame(line: Line2D, y: float) -> void:
	# Move points to left
	for i in range(line.get_point_count()):
		var point = line.get_point_position(i)
		point.x -= 1
		line.set_point_position(i, point)
		
	# Remove if off left side
	if (line.get_point_position(0).x < graph_left):
		line.remove_point(0)
	
	# Add new point
	line.add_point(new_graph_vector(y))
	
	
func new_graph_vector(y: float) -> Vector2:
	return Vector2(graph_right, ((graph_height - y) + graph_margin) - below_zero)
