class_name GravitationalPath3D
extends Path3D


@export var surface_curve : Curve
@export var target: Node3D
@export var dummy: Node3D
@export var path_follow: PathFollow3D


func test_closest_offset() -> void:
	var offset = curve.get_closest_offset(to_local(target.global_position))
	print(offset)
	var progress = offset / curve.get_baked_length()
	print(progress)


func test_closet_point() -> void:
	var point = curve.get_closest_point(to_local(target.global_position))
	dummy.global_position = to_global(point)
