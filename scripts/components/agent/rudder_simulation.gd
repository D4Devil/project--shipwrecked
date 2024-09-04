class_name RudderSimulation
extends Node
## Node that controls a constant rotation of a PhysicsBody3D on it's UP direction.
## Max rotation is delimited in degrees.
##
## Uses the _physics_proces callback to apply a constant rotation to the PhysicsBody3D on
## it's own Up direction.

## [Dependency]: To whom this simulation will be applied 
@export var body: PhysicsBody3D

## [Animation Helper]: Represents the turning of the Rudder (wheel) that controls the direction.
## This member will NOT affect the direction of the body, and its only intended for visual representations
@export var max_spin_angle: float = 180

## Half of the openes of the direction angle. The limits will be defined as [-value, value] inclusive so,
## for a 90 degree total direction angle max_rotation_angle must be 45.
@export var max_rotation_angle: float = 45

## Spining speed, it's a magic number. Test it, Tune it, Repeat. 
@export var spin_speed: float = 100

var _current_spin: float = 0
var _current_direction_angle: float = 0 

## Emitted ONLY when the rotation of the rudder has changed
signal rudder_spun(current_spin: float, current_direction_angle: float)


## Simulate the rudder spining, positive and negative values determine opposite directions
## while the absolut value is yet another speed factor (use -1 or 1 to avoid impact on the speed).
func spin(direction_factor: float) -> void:
	var target_spin = _current_spin + direction_factor * spin_speed
	_current_spin = clampf(target_spin, -max_spin_angle, max_spin_angle)
	_current_direction_angle = max_rotation_angle / (max_spin_angle) * _current_spin

	if _current_spin == -max_spin_angle or _current_spin == max_spin_angle:
		return ## don't emit if the _current_spin is on the limit
	rudder_spun.emit(_current_spin, _current_direction_angle)


func _physics_process(delta):
	body = body as CharacterBody3D
	body.rotate_object_local(Vector3.UP, deg_to_rad(-_current_direction_angle * delta))
