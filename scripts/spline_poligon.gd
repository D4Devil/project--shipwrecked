@tool
class_name SplinePolygon
extends Path3D


@export var spline_thickness_curve: Curve
@export var tube_segments : int = 6
@export var mesh_instance : MeshInstance3D

## https://www.reddit.com/r/bevy/comments/17yjlrf/rendering_a_3d_tube_from_a_curve/

func _ready() -> void:
	var array_mesh := ArrayMesh.new()
	var vertex : PackedVector3Array = []

	for sample in curve.get_baked_points():
		var offset := curve.get_closest_offset(sample)
		var sample_transform := curve.sample_baked_with_rotation(offset)

		for idx in tube_segments:
			var angle = (float(idx)/float(tube_segments)) * 360
			var point = Vector3.UP.rotated(Vector3.FORWARD, deg_to_rad(angle))
			vertex.append(sample_transform * point)


	var surface_arrays = []
	surface_arrays.resize(Mesh.ARRAY_MAX)
	surface_arrays[Mesh.ARRAY_VERTEX] = vertex

	array_mesh.add_surface_from_arrays(
		Mesh.PRIMITIVE_POINTS,
		surface_arrays
	)

	mesh_instance.mesh = array_mesh
	

# ## place it at the start of the curve
# func _process(_delta: float):
# 	# for sample_position in curve.get_baked_points():
# 	# 	project_polygon_at_node(sample_position)

# 	pass



# func project_polygon_at_node(sample_position: Vector3) -> void:
# 	var node_offset = curve.get_closest_offset(sample_position)
# 	var node_transform := curve.sample_baked_with_rotation(node_offset)

# 	# for point in polygon:
# 	# 	var new_point = node_transform.basis * point
# 	# 	new_point += sample_position
# 	# 	print(new_point)
# 	# 	var nt = Transform3D(node_transform)
# 	# 	nt.origin = point + sample_position
		

## rotate it to match the oposite normal of the starting point curve
## offset it using the curve3d and the curve to get the distance to the node
## extrude it (ptional, use the curves sampling to position the extruded vertices)
## offset the extrusion
## on end, close the shape
