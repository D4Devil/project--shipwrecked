class_name GravitationalBody3D
extends Node3D

@export var body : PhysicsBody3D

@export var _gravity_direction = Vector3.DOWN * 9.81:
	set = set_gravity_direction


signal gravity_changed(new_gravity: Vector3) 


func _ready():
	body.add_to_group("gravitational_body")


func _physics_process(delta):
	if body is CharacterBody3D:
		body = body as CharacterBody3D
		body.move_and_collide(_gravity_direction * delta)
	
	if body is RigidBody3D:
		pass ## adding forces


func set_gravity_direction(value: Vector3) -> void:
	_gravity_direction = value
	gravity_changed.emit()
