class_name AimStraight
extends Node3D

@export var horizontal_pivot: Node3D
@export var vertical_pivot: Node3D

@export var horizontal_speed: float
@export var vertical_speed: float

@export var line_length: float
@export var line_color: Color

func _init():
	_on_aim_active(false)

var horizontal_movement: float = 0
var vertical_movement: float = 0


func _process(delta: float) -> void:
	horizontal_pivot.rotate(Vector3.UP, deg_to_rad(horizontal_movement * horizontal_speed * delta))
	vertical_pivot.rotate(Vector3.RIGHT, deg_to_rad(vertical_movement * vertical_speed * delta))
	Utils.line(self, global_position, global_position + transform.basis.z, line_color, 1)


func _on_aim_active(active:bool) -> void:
	if active:
		process_mode = PROCESS_MODE_INHERIT
	else:
		process_mode = PROCESS_MODE_DISABLED
		
