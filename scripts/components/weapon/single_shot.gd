class_name SingleShot
extends Node3D

@export var projectile_scene: PackedScene
@export var origin: Node3D
@export var origin_physics_body: PhysicsBody3D
@export var ignored_colliders : Array[CollisionObject3D]

func _on_weapon_fired(can_be_charged: bool, current_charge: float, _minimum_charging_time: float, _maximum_charging_time: float) -> void:
	var current_projectile := projectile_scene.instantiate() as Node3D
	for collider in ignored_colliders:
		(current_projectile as PhysicsBody3D).add_collision_exception_with(collider)

	var velocity := -origin.global_basis.z.normalized()

	for property in current_projectile.get_property_list():
		if property['name'] == 'initial_velocity':
			velocity *= current_projectile.initial_velocity

	if origin_physics_body is CharacterBody3D:
		origin_physics_body = origin_physics_body as CharacterBody3D
		velocity += origin_physics_body.get_last_motion()
	
	if origin_physics_body is RigidBody3D:
		origin_physics_body = origin_physics_body as RigidBody3D
		velocity += origin_physics_body.linear_velocity

	if can_be_charged:
		velocity *= current_charge

	if current_projectile is CharacterBody3D:
		current_projectile = current_projectile as CharacterBody3D
		current_projectile.velocity += velocity

	elif current_projectile is RigidBody3D:
		current_projectile = current_projectile as RigidBody3D
		current_projectile.apply_central_force(velocity)
	
	else:
		print("Firing something unknown")

	get_tree().current_scene.add_child(current_projectile)
	current_projectile.global_position = origin.global_position
