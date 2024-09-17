class_name AntigravityArea3D
extends Area3D

@export var antigravity_space_override: SpaceOverride = SpaceOverride.SPACE_OVERRIDE_COMBINE
@export var gravity_force: float
var _bodies: Array[AntigravityBody3D]

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)


func on_body_entered(body: Node3D) -> void:
	print(body.name + " entered the area")

	var antigravity_nodes := body.find_children("*", "AntigravityBody3D", false)
	if not antigravity_nodes:
		return

	for node in antigravity_nodes:
		if not _bodies.has(node): 
			_bodies.append(node)


func on_body_exited(body: Node3D) -> void:
	print(body.name + " exited the area")

	var antigravity_nodes := body.find_children("*", "AntigravityBody3D", false)
	if not antigravity_nodes:
		return

	for node in antigravity_nodes:
		if _bodies.has(node):
			_bodies.erase(body)


func _physics_process(_delta: float) -> void:

	## [Prototype] Sphere Collider	
	for body in _bodies:
		var new_dir = body.global_position.direction_to(global_position)
		body.set_update_gravity(self, new_dir * gravity_force)
	