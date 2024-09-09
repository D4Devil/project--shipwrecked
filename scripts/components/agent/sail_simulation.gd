class_name SailSimulation
extends Node
## Node that controls a set of speeds, like gears in a car's transmision. [br]
## Simulates the different states of a deployed sail (Not deployed, half-deployed, fully-deployed, etc.)
##
## Uses the _physics_process callback to constantly push a PhysicsBody3D towards it's own
## forward direction.


## [Dependency]: To whom this simulation will be applied
@export var physics_body: PhysicsBody3D

## Your custom set of speeds
@export var _sail_speeds : Array[float] = [0, 30, 70,]
@export var _acceleration : float = 1
var _current_sail_speed : float = 0

## The position of the sail state 
var _current_sail_idx : int = 0


## Emmited ONLY when a sail shift occurs succesfully.
## Contains the state (idx), and the new sailing speed
signal sail_changed(idx: int, speed: float)


## Shifts up (positive) or down (negative) x positions on the sail speeds array
## ignore if the opertation is out of range
func sail_shift(shitfts := 1) -> void:
	var target_idx = _current_sail_idx + shitfts

	if target_idx < 0 or target_idx >= _sail_speeds.size(): ## Invalid sail shift
		return 
	
	_current_sail_idx = target_idx
	sail_changed.emit(_current_sail_idx, _sail_speeds[_current_sail_idx])


func _physics_process(delta: float):
	physics_body = physics_body as CharacterBody3D

	var directioned_acceleration = _acceleration
	if _sail_speeds[_current_sail_idx] < _current_sail_speed:
		directioned_acceleration = -directioned_acceleration

	_current_sail_speed += directioned_acceleration
	clampf(_current_sail_speed, 0, _sail_speeds[_current_sail_idx])
	physics_body.move_and_collide(-physics_body.basis.z.normalized() * _current_sail_speed * delta)


func get_current_speed() -> float:
	return _current_sail_speed
