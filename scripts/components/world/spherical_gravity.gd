extends Area3D

@export var gravity_force: float
var _bodies: Array

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)


func on_body_entered(body: Node3D) -> void:
	print(body.name + " entered the area")

	if not body.is_in_group("gravitational_body"):
		return

	var gravity_nodes := body.find_children("*", "GravitationalBody3D")
	if not gravity_nodes:
		return

	_bodies.append_array(gravity_nodes)


func on_body_exited(body: Node3D) -> void:
	print(body.name + " exited the area")

	if body is not GravitationalBody3D || !_bodies.has(body as GravitationalBody3D):
		return
	
	_bodies.erase(body)


func _process(_delta: float) -> void:
	for body in _bodies:
		body.set_gravity_direction(body.global_position.direction_to(global_position) * gravity_force)
	print('test')
