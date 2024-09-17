class_name ForceIntegrator
extends Area3D


var _recalculate_gravity_forces: bool = true
var _gravity_forces: Array[Force] = []
var _gravity := Vector3.ZERO

var _recalculate_continuous_forces := true
var continuous_forces: Array[Force] = []
var _continuous_force : Vector3 = Vector3.ZERO

var momentary_forces : PackedVector3Array = []
var _momentary_force := Vector3.ZERO


func _physics_process(_delta: float) -> void:
	if momentary_forces.size() == 0:
		return

	_momentary_force = Vector3.ZERO
	for mmt_f in momentary_forces:
		_momentary_force += mmt_f
		## call a signal? maybe
	momentary_forces.clear()

	get_continous_force()
	get_gravity_force()



func get_gravity_force() -> Vector3:
	if _recalculate_gravity_forces:
		_gravity = Vector3.ZERO

		for force in _gravity_forces:
			_gravity += force.value

		## call a signal??
		_recalculate_gravity_forces = false

	return _gravity


func get_continous_force() -> Vector3:
	if _recalculate_continuous_forces:
		_continuous_force = Vector3.ZERO

		for force in continuous_forces:
			_continuous_force += force.value

		## call a signal?
		_recalculate_continuous_forces = false

	return _continuous_force


func set_or_update_continous_force(source, value: Vector3, is_gravity_force := false):
	var forces = _gravity_forces if is_gravity_force else continuous_forces
	for force in forces:
		if force.source == source:
			if force.value != value:
				force.value = value
				if is_gravity_force:
					_recalculate_gravity_forces = true
				else:
					_recalculate_continuous_forces = true
			return

	forces.append(Force.new(source, value))


func remove_continuous_force(source, is_gravity_force := false) -> void:
	var forces = _gravity_forces if is_gravity_force else continuous_forces
	for idx in forces.size():
		if forces[idx] == source:
			forces.remove_at(idx)

			if is_gravity_force:
				_recalculate_gravity_forces = true
			else:
				_recalculate_continuous_forces = true
			break


class Force:
	var source
	var value := Vector3.ZERO


	func _init(_source: Node, _value: Vector3):
		source = _source
		value = _value
