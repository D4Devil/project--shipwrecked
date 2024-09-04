extends Node

@export var rudder : RudderSimulation
@export var rudder_speed: float
@export var sail : SailSimulation


func _unhandled_input(event):
	if event.is_action("ui_left"):
		rudder.spin(-1 * rudder_speed)
	
	if event.is_action("ui_right"):
		rudder.spin(rudder_speed)

	if event.is_action_pressed("ui_accept"):
		sail.sail_shift(1)

	if event.is_action_pressed("ui_cancel"):
		sail.sail_shift(-1)
