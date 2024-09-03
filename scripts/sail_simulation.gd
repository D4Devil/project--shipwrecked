class_name SailSimulation
extends Node

## Component that controls a set of speeds, like gears in a car's transmision. [br]
## Simulates the different states of a deployed sail (Not deployed, half-deployed, fully-deployed, etc.)

## [Dependency]: To whom this simulation will be applyed
@export var body: PhysicsBody3D

## Your custom set of speeds
@export var _sail_speeds : Array[float]

## The cached position of the sail state 
@export var _current_sail_idx : int = 0


## Emmited ONLY when a sail shift occurs succesfully.
## Contains the state (idx), and the new sailing speed
signal sail_changed(idx: int, speed: float)


## Shifts up (positive) or down (negative) x positions on the sail speeds array
## ignore if the opertation is out of range
func sail_shift(shitfts := 1) -> void:
	var target_idx = _current_sail_idx + shitfts

	if target_idx < 0 or target_idx >= _sail_speeds.size(): ## Invalid sail shift
		push_warning("Sail shift cannot be performed, index out of range.")
		return 
	
	_current_sail_idx = target_idx
	sail_changed.emit(_current_sail_idx, _sail_speeds[_current_sail_idx])


func _physics_process(delta: float):
	body = body as CharacterBody3D
	body.move_and_collide(-body.basis.z * _sail_speeds[_current_sail_idx] * delta)


func get_current_speed() -> float:
	return _sail_speeds[_current_sail_idx]
