@tool
class_name SplinePolygon
extends Path3D

@export var spline_thickness_curve: Curve
@export var tube_segments : int = 4
@onready var mesh_instance : MeshInstance3D = MeshInstance3D.new()

## The basics of creating geometry
## https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/index.html

## The basics of using the ArrayMesh, the right resource for this case
## https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/arraymesh.html#doc-arraymesh

## Crude Example of wrapping the curve with a mesh
## https://www.reddit.com/r/bevy/comments/17yjlrf/rendering_a_3d_tube_from_a_curve/


func _ready() -> void:
	add_child(mesh_instance)
	bake_mesh_and_collider()


func bake_mesh_and_collider():
	var array_mesh := ArrayMesh.new()
	var vertex : PackedVector3Array = []
	var triangles: PackedVector3Array = []

	## Iterate over the points sampled by the Curve3D
	for sample in curve.get_baked_points():
		var offset := curve.get_closest_offset(sample)

		## Getting the transform is the easiest way to transfer the rotation data from a sampled point to a Vector
		var sample_transform := curve.sample_baked_with_rotation(offset)

		## Generate the points, can be seen as a regular polygon that gives the tube the side count.
		## This can be changed later to use a user-provided polygon, it's fine for now
		for idx in tube_segments:
			var angle = (float(idx)/float(tube_segments)) * 360

			## Rotate the point (Vector) before applying the sample transformations 
			var point = Vector3.UP.rotated(Vector3.FORWARD, deg_to_rad(angle))

			## Offset the point by a sample taken from the Curve
			point *= spline_thickness_curve.sample(offset/curve.get_baked_length())

			## Apply sample transformations to the point
			vertex.append(sample_transform * point)
	
	## Construct the triangles, iterate over the vertex array except for the last ring
	for idx in (vertex.size() - tube_segments - 1):
		triangles.append_array([
			vertex[idx],
			vertex[idx + tube_segments],
			vertex[idx + tube_segments + 1],
			vertex[idx],
			vertex[idx + tube_segments + 1],
			vertex[idx + 1]
		])

	## The array of arrays that will define the mesh
	var surface_arrays = []
	surface_arrays.resize(Mesh.ARRAY_MAX)
	surface_arrays[Mesh.ARRAY_VERTEX] = triangles

	array_mesh.add_surface_from_arrays(
		Mesh.PRIMITIVE_TRIANGLES,
		surface_arrays
	)

	## TODO: If insted I use a mesh already provided to the MeshInstance3D, the mesh will not be rendered or updated,
	## can resources be changed on the fly? or should I call additional methods to update the render?... 
	mesh_instance.mesh = array_mesh

	## Onece the trimesh is ready, i can call this function to create the collider, only suitable for static collisions
	#mesh_instance.create_trimesh_collision()
