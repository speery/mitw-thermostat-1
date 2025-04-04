extends Node

const FURNACE_STATE_OFF = "Off"
const FURNACE_STATE_ON = "On"

var thermostat_value: int = 70
var error_threshold: int = 1
var frame_rate: float = 1.0
var error_value: int = 0
var furnace_temp_value: int = 70
var furnace_max_value: int = 180
var perception_value: int = 70
var outside_value: int = 70
var r_value: float = .01
var furnace_state = FURNACE_STATE_OFF
var inside_value1: float = 70
var inside_value2: float = 70 
var inside_value3: float = 70 
var inside_value4: float = 70 
var inside_value5: float = 70 
var inside_value6: float = 70 
var inside_value7: float = 70 
var inside_value8: float = 70


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_display_values_from_variables()
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_pause_button_toggled(toggled_on: bool) -> void:
	$Timer.set_paused(toggled_on)


func _on_reset_button_button_up() -> void:
	reset_vars()
	set_display_values_from_variables()
	$Bkgnd/ThermostatSlider.value = thermostat_value
	$Bkgnd/ErrorThresholdSlider.value = error_threshold
	$Bkgnd/FurnaceMaxSlider.value = furnace_max_value
	$Bkgnd/OutsideSlider.value = outside_value
	
	
func _on_timer_timeout() -> void:
	
	# Heat Gain/Loss	
	inside_value8 = heat_gain(inside_value8)
	inside_value7 = heat_gain(inside_value7)
	inside_value6 = heat_gain(inside_value6)
	inside_value5 = heat_gain(inside_value5)
	inside_value4 = heat_gain(inside_value4)
	inside_value3 = heat_gain(inside_value3)
	inside_value2 = heat_gain(inside_value2)
	inside_value1 = heat_gain(inside_value1)
	
	if furnace_state == FURNACE_STATE_ON:
		furnace_temp_value = furnace_temp_value + 1
		if furnace_temp_value > furnace_max_value:
			furnace_temp_value = furnace_max_value
		
		# Set heat wave
		inside_value8 = inside_value7
		inside_value7 = inside_value6
		inside_value6 = inside_value5
		inside_value5 = inside_value4
		inside_value4 = inside_value3
		inside_value3 = inside_value2
		inside_value2 = inside_value1
		inside_value1 = furnace_temp_value	
	
	else: # FURNACE_STATE_OFF
		if furnace_temp_value > inside_value1:
			furnace_temp_value = furnace_temp_value - 1
		
		var average = inside_value_average() # Get local value. Average will change as convection is called below
		convection(inside_value1, average)
		convection(inside_value2, average)
		convection(inside_value3, average)
		convection(inside_value4, average)
		convection(inside_value5, average)
		convection(inside_value6, average)
		convection(inside_value7, average)
		convection(inside_value8, average)
		
	perception_value = inside_value8
	
	calculate_variables()
	set_display_values_from_variables()
	

# Thermostat Slider
func _on_thermostat_slider_drag_started() -> void:
	$Timer.set_paused(true)


func _on_thermostat_slider_drag_ended(value_changed: bool) -> void:
	drag_ended(value_changed)
	
	
func _on_thermostat_slider_value_changed(value: float) -> void:
	thermostat_value = value
	error_value = thermostat_value - perception_value 
	if (error_value < 0):
		error_value = 0
		
	$Bkgnd/ThermostatValue.text = str(value as int)
	$Bkgnd/ErrorValue.text = str(error_value as int)
	

	

# Error Threshold Slider
func _on_error_threshold_slider_drag_started() -> void:
	$Timer.set_paused(true)


func _on_error_threshold_slider_drag_ended(value_changed: bool) -> void:
	drag_ended(value_changed)


func _on_error_threshold_slider_value_changed(value: float) -> void:
	error_threshold = value
	$Bkgnd/ErrorThresholdValue.text = str(value as int)
	

# Frame Rate Slider
func _on_frame_rate_slider_drag_started() -> void:
	pass # Replace with function body.


func _on_frame_rate_slider_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.


func _on_frame_rate_slider_value_changed(value: float) -> void:
	frame_rate = value
	$Bkgnd/FrameRateValue.text = str(value)
	$Timer.set_wait_time(1/value)



# Outside Slider
func _on_outside_slider_drag_started() -> void:
	$Timer.set_paused(true)


func _on_outside_slider_drag_ended(value_changed: bool) -> void:
	drag_ended(value_changed)


func _on_outside_slider_value_changed(value: float) -> void:
	outside_value = value
	$Bkgnd/OutsideValue.text = str(value as int)


# Furnace Max
func _on_furnace_max_slider_drag_started() -> void:
	$Timer.set_paused(true)


func _on_furnace_max_slider_drag_ended(value_changed: bool) -> void:
	drag_ended(value_changed)


func _on_furnace_max_slider_value_changed(value: float) -> void:
	furnace_max_value = value
	$Bkgnd/FurnaceMaxValue.text = str(value as int)


# Util Methods
func reset_vars() -> void:
	thermostat_value = 70
	error_threshold = 1
	error_value = 0
	furnace_temp_value = 70
	furnace_max_value = 180
	perception_value = 70
	outside_value = 70
	r_value = .01
	furnace_state = FURNACE_STATE_OFF
	inside_value1 = 70
	inside_value2 = 70 
	inside_value3 = 70 
	inside_value4 = 70 
	inside_value5 = 70 
	inside_value6 = 70 
	inside_value7 = 70 
	inside_value8 = 70

func inside_value_average() -> float:
	return (inside_value1 + inside_value2 + inside_value3 + inside_value4 +
			inside_value5 + inside_value6 + inside_value7 + inside_value8) / 8
	
func heat_gain(inside_value: float) -> float:
	return inside_value + ((outside_value - inside_value) * r_value)
	
	
func convection(value, average): 
	return value + ((average - value) * .5)
	
	
func drag_ended(value_changed: bool) -> void:
	if (value_changed): 
		calculate_variables()
		set_display_values_from_variables()	
		if (!$Bkgnd/PauseButton.is_pressed()):
			$Timer.set_paused(false)


func calculate_variables() -> void:
	error_value = thermostat_value - perception_value 
	if (error_value < 0):
		error_value = 0
		
	if (furnace_state == FURNACE_STATE_OFF):
		if (error_value > error_threshold):
			furnace_state = FURNACE_STATE_ON
	else:
		if (error_value == 0):
			furnace_state = FURNACE_STATE_OFF	

func set_display_values_from_variables() -> void:
	$Bkgnd/ThermostatValue.text = str(thermostat_value)
	$Bkgnd/ErrorThresholdValue.text = str(error_threshold)
	$Bkgnd/ErrorValue.text = str(error_value)
	$Bkgnd/PerceptionValue.text = str(perception_value)
	$Bkgnd/OutsideValue.text = str(outside_value)
	$Bkgnd/FurnaceState.text = furnace_state
		
	$Bkgnd/FurnaceTemp.text = str(furnace_temp_value)
	$Bkgnd/InsideValue1.text = str("%.2f" % inside_value1)
	$Bkgnd/InsideValue2.text = str("%.2f" % inside_value2)
	$Bkgnd/InsideValue3.text = str("%.2f" % inside_value3)
	$Bkgnd/InsideValue4.text = str("%.2f" % inside_value4)
	$Bkgnd/InsideValue5.text = str("%.2f" % inside_value5)
	$Bkgnd/InsideValue6.text = str("%.2f" % inside_value6)
	$Bkgnd/InsideValue7.text = str("%.2f" % inside_value7)
	$Bkgnd/InsideValue8.text = str("%.2f" % inside_value8)
	$Bkgnd/InsideValueAverage.text = str("%.2f" % inside_value_average())
