@tool
class_name AntigravityBody3D
extends Node3D
## Node that provides custom-gravity support, to be used along
## with a GravityField3D.
##
## Uses the _physics_process callback to apply a constant force to the given PhysicsBody3D


## Gravity scalar for tunning
@export var gravity_scalar: float = 1

## [Dependency]: To whom this simulation will be applied
var physics_body : Node3D :
	set(value):
		physics_body = value
		update_configuration_warnings()

## Set an static var for antigravity_layer
# @export static var antigravity_layer = 2

var _current_gravity = Vector3.ZERO
var _antigravity_values: Dictionary = {}
var _antigravity_fields: Array[AntigravityArea3D] = []


## Triggered when the direction of the gravity changes
signal gravity_changed(new_gravity: Vector3)


func _physics_process(delta):
	if Engine.is_editor_hint():
		return

	_compute_gravity()

	if gravity_changed:
		gravity_changed.emit(_current_gravity)

	if physics_body is CharacterBody3D:
		physics_body = physics_body as CharacterBody3D
		physics_body.move_and_collide(_current_gravity  * delta * gravity_scalar)
	
	if physics_body is RigidBody3D:
		physics_body = physics_body as RigidBody3D
		physics_body.apply_central_force(_current_gravity * delta * gravity_scalar)


func _compute_gravity() -> void:
	_antigravity_fields.sort_custom(func(a: Area3D, b: Area3D): return a.priority > b.priority)
	_current_gravity = Vector3.ZERO
	var _gravity_done = false
	for field in _antigravity_fields:
		if _gravity_done:
			break

		match field.antigravity_space_override:
			Area3D.SPACE_OVERRIDE_COMBINE or \
			Area3D.SPACE_OVERRIDE_COMBINE_REPLACE:
				_current_gravity += _antigravity_values[field.get_rid()]
				_gravity_done = field.antigravity_space_override == Area3D.SpaceOverride.SPACE_OVERRIDE_COMBINE_REPLACE
			
			Area3D.SPACE_OVERRIDE_REPLACE or \
			Area3D.SPACE_OVERRIDE_REPLACE_COMBINE:
				_current_gravity = _antigravity_values[field.get_rid()]
				_gravity_done = field.antigravity_space_override == Area3D.SPACE_OVERRIDE_REPLACE


## Hook or interface for AntigravityArea3D
func set_update_gravity(source: AntigravityArea3D, value: Vector3) -> void:
	_antigravity_values[source.get_rid()] = value
	_antigravity_fields.append(source)


func _enter_tree() -> void:
	physics_body.set_collision_layer_value(2, true)


func _exit_tree() -> void:
	if physics_body:
		physics_body.set_collision_layer_value(2, false)


func _notification(what: int) -> void:
	if what == NOTIFICATION_PARENTED:
		physics_body = get_parent()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if physics_body is not PhysicsBody3D:
		warnings.append("AntigravityBody3D: " + name + ", must be child of a PhysicsBody3D node")
	return warnings
