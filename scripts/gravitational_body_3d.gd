extends Node3D

@export var body : PhysicsBody3D

var _gravity_direction = Vector3.ZERO :
	set = set_gravity_direction

var _gravity_force = 0.0 :
	set = set_gravity_force


signal gravity_changed(direction: Vector3, force: float) 


func _physics_process(delta):
	if body is CharacterBody3D:
		body = body as CharacterBody3D
		body.move_and_collide(_gravity_direction * _gravity_force * delta)
		## move and slide / collide
	
	if body is RigidBody3D:
		pass ## adding forces


func set_gravity_direction(value: Vector3) -> void:
	_gravity_direction = value
	gravity_changed.emit(_gravity_direction, _gravity_force)


func set_gravity_force(value: float) -> void:
	_gravity_force = value
	gravity_changed.emit(_gravity_direction, _gravity_force)
