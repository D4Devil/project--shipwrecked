class_name GravitationalBody3D
extends Node3D
## Node that provides custom-gravity support, to be used along
## with a GravityField3D.
##
## Uses the _physics_process callback to apply a constant force to the given PhysicsBody3D

## [Dependency]: To whom this simulation will be applied
@export var physics_body : PhysicsBody3D :
	set(value):
		update_configuration_warnings()
		physics_body = value

## Gravity scalar for tunning
@export var gravity_scalar: float = 1

## Current gravity direction state
@export var _gravity_direction = Vector3.DOWN * 9.81:
	set = set_gravity_direction


var _notify_missing_force_integrator: bool = false :
	set(value):
		update_configuration_warnings()
		_notify_missing_force_integrator = value


## Triggered when the direction of the gravity changes
signal gravity_changed(new_gravity: Vector3) 


func _init() -> void:
	pass

# func _physics_process(delta):
# 	if Engine.is_editor_hint():
# 		return

# 	if physics_body is CharacterBody3D:
# 		physics_body = physics_body as CharacterBody3D
# 		physics_body.move_and_collide(_gravity_direction  * delta * gravity_scalar)
	
# 	if physics_body is RigidBody3D:
# 		physics_body = physics_body as RigidBody3D
# 		physics_body.apply_central_force(_gravity_direction * delta * gravity_scalar)


func set_gravity_direction(value: Vector3) -> void:
	_gravity_direction = value
	gravity_changed.emit(_gravity_direction)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if _notify_missing_force_integrator:
		warnings.append("GravitationalBody3D: " + name + " must be child of a ForceIntegrator node")

	if not physics_body:
		warnings.append("A physics body must be provided")

	return warnings


func _notification(what: int) -> void:
	if what == NOTIFICATION_PARENTED:
		if get_parent() is not ForceIntegrator:
			_notify_missing_force_integrator = true
		else:
			_notify_missing_force_integrator = false


func _enter_tree() -> void:
	physics_body.set_collision_layer_value(2, true)


func _exit_tree() -> void:
	if physics_body:
		physics_body.set_collision_layer_value(2, false)
