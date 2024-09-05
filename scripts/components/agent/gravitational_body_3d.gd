class_name GravitationalBody3D
extends Node3D
## Node that provides custom-gravity support, to be used along
## with a GravityField3D.
##
## Uses the _physics_process callback to apply a constant force to the given PhysicsBody3D

## [Dependency]: To whom this simulation will be applied
@export var physics_body : PhysicsBody3D

## Current gravity direction state
@export var _gravity_direction = Vector3.DOWN * 9.81:
	set = set_gravity_direction

## Triggered when the direction of the gravity changes
signal gravity_changed(new_gravity: Vector3) 


func _physics_process(delta):
	if physics_body is CharacterBody3D:
		physics_body = physics_body as CharacterBody3D
		physics_body.move_and_collide(_gravity_direction * delta)
	
	if physics_body is RigidBody3D:
		pass ## adding forces


func set_gravity_direction(value: Vector3) -> void:
	_gravity_direction = value
	gravity_changed.emit()


func _enter_tree() -> void:
	assert(physics_body, "A Physics physics_body must be provided")
	physics_body.set_collision_layer_value(2, true)


func _exit_tree() -> void:
	if physics_body:
		physics_body.set_collision_layer_value(2, false)
