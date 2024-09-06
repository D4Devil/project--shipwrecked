class_name SingleShot
extends Node

@export var projectile_scene: PackedScene
@export var spawner: Node3D
@export var ignored_colliders : Array[CollisionObject3D]

func _on_weapon_fired(can_be_charged: bool, current_charge: float, _minimum_charging_time: float, _maximum_charging_time: float) -> void:
	var current_projectile := projectile_scene.instantiate()
	
	for collider in ignored_colliders:
		(current_projectile as PhysicsBody3D).add_collision_exception_with(collider)

	var velocity := -spawner.global_basis.z.normalized() 
	if can_be_charged:
		velocity *= current_charge

	for property in current_projectile.get_property_list():
		if property['name'] == 'initial_velocity':
			velocity *= current_projectile.initial_velocity

	if current_projectile is CharacterBody3D:
		current_projectile = current_projectile as CharacterBody3D
		current_projectile.velocity += velocity

	elif current_projectile is RigidBody3D:
		current_projectile = current_projectile as RigidBody3D
		current_projectile.apply_central_force(velocity)
	
	else:
		print("Firing something unknown")

	add_child(current_projectile)
