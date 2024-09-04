class_name SphericalGravity
extends Area3D

@export var gravity_force: float
var _bodies: Array

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)


func on_body_entered(body: Node3D) -> void:
	print(body.name + " entered the area")

	var gravity_nodes := body.find_children("*", "GravitationalBody3D")
	if not gravity_nodes:
		return

	for node in gravity_nodes:
		if not _bodies.has(node): 
			_bodies.append(node)


func on_body_exited(body: Node3D) -> void:
	print(body.name + " exited the area")

	var gravity_nodes := body.find_children("*", "GravitationalBody3D")
	if not gravity_nodes:
		return

	for node in gravity_nodes:
		if _bodies.has(node):
			_bodies.erase(body)


func _physics_process(_delta: float) -> void:
	for body in _bodies:
		var new_dir = body.global_position.direction_to(global_position)
		body.set_gravity_direction(new_dir * gravity_force)
