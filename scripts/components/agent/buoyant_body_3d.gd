class_name BuoayantBody
extends Node3D


@export var body: Node3D
var downwards :
	set = set_downwards


func set_downwards(direction) -> void:
	downwards = direction


func _physics_process(_delta: float) -> void:
	if downwards:
		var x = body.basis.z.cross(downwards)
		body.look_at(body.transform.origin + (x.cross(downwards)), -downwards)
