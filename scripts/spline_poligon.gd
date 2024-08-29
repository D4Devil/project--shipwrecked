@tool
class_name SplinePolygon
extends Path3D

@export var spline_thickness_curve: Curve
@export var tube_segments : int = 6
@export var mesh_instance : MeshInstance3D

## The basics of creating geometry
## https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/index.html

## The basics of using the ArrayMesh, the right resource for this case
## https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/arraymesh.html#doc-arraymesh

## Crude Example of wrapping the curve with a mesh
## https://www.reddit.com/r/bevy/comments/17yjlrf/rendering_a_3d_tube_from_a_curve/


func _ready() -> void:
	var array_mesh := ArrayMesh.new()
	var vertex : PackedVector3Array = []

	## Iterate over the points sampled by the Curve3D
	for sample in curve.get_baked_points():
		var offset := curve.get_closest_offset(sample)

		## Getting the transform is the easiest way to transfer the rotation data from a sampled point to a Vector
		var sample_transform := curve.sample_baked_with_rotation(offset)

		## Generate the points can be seen as the regular polygon that gives the shape.
		## This can be changed later to use a user-provided polygon, it's fine for now
		for idx in tube_segments:
			var angle = (float(idx)/float(tube_segments)) * 360

			## Rotate the point (Vector) before applying the sample transformations 
			var point = Vector3.UP.rotated(Vector3.FORWARD, deg_to_rad(angle))

			## Offset the point by a sample taken from the Curve
			point *= spline_thickness_curve.sample(offset/curve.get_baked_length())

			## Apply sample transformations to the point
			vertex.append(sample_transform * point)

	## The array of arrays that will define the mesh
	var surface_arrays = []
	surface_arrays.resize(Mesh.ARRAY_MAX)
	surface_arrays[Mesh.ARRAY_VERTEX] = vertex

	array_mesh.add_surface_from_arrays(
		Mesh.PRIMITIVE_POINTS,
		surface_arrays
	)

	## TODO: If insted I use a mesh already provided to the MeshInstance3D, the mesh will not be rendered or updated,
	## can resources be changed on the fly? or should I call additional methods to update the render?... 
	mesh_instance.mesh = array_mesh
