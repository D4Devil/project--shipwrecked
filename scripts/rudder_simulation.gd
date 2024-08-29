class_name RudderSimulation
extends Node

@export var max_spin_angle: float = 180
@export var spin_speed: float = 100
@export var max_rotation_angle: float = 45
@export var body: PhysicsBody3D
var _current_spin: float = 0
var _current_direction_angle: float = 0 


signal rudder_spun(current_spin: float, current_direction_angle: float)

## direction_factor with it's sing the direction of the rotation, while 
## the value is used as a speed factor
func spin(direction_factor: float) -> void:
	var target_spin = _current_spin + direction_factor * spin_speed
	_current_spin = clampf(target_spin, -max_spin_angle, max_spin_angle)
	_current_direction_angle = max_rotation_angle / (max_spin_angle) * _current_spin
	rudder_spun.emit(_current_spin, _current_direction_angle)


func _physics_process(delta):
	body = body as CharacterBody3D
	body.rotate_object_local(Vector3.UP, deg_to_rad(-_current_direction_angle * delta))
