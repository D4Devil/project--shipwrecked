extends Node

@export var rudder : RudderSimulation
@export var rudder_speed: float
@export var sail : SailSimulation
@export var weapon: Weapon


func _physics_process(_delta: float) -> void:
	sail_input_handle()
	rudder_input_handle()
	weapon_input_handle()

func sail_input_handle() -> void:
	if Input.is_action_pressed("in_game_r_b"):
		sail.sail_shift(1)

	if Input.is_action_pressed("in_game_l_b"):
		sail.sail_shift(-1)

 
func rudder_input_handle() -> void:
	var axis = Input.get_axis("in_game_l_left", "in_game_l_right")
	rudder.spin(axis * rudder_speed)


func weapon_input_handle():
	if Input.is_action_just_pressed("in_game_l_t"):
		weapon._active = true
	
	if Input.is_action_just_released("in_game_l_t"):
		weapon._active = false

	if Input.is_action_just_pressed("in_game_r_t"):
		weapon.on_weapon_fired()
