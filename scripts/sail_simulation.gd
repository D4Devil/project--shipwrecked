class_name SailSimulation
extends Node

@export var _sail_speeds : Array[float]
@export var _current_sail_idx : int = 0

signal sail_changed(idx: int, speed: float)


## Shift up (positive) or down (negative) x positions on the sail speeds array
## ignore if the opertation is out of range
func sail_shift(shitfts := 1) -> void:
	var target_idx = _current_sail_idx + shitfts
	assert(target_idx >= 0 and target_idx <= _sail_speeds.size() - 1, "Sail shift cannot be performed, index out of range.")
	if target_idx >= 0 and target_idx <= _sail_speeds.size() - 1:
		_current_sail_idx = target_idx
		sail_changed.emit(_current_sail_idx, _sail_speeds[_current_sail_idx])
