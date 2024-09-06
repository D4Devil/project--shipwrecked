class_name Weapon
extends Node3D

# General Weapon Variables
@export var _cooldown: float = 0:
	set(value):
		_cooldown = value
		update_cooldowm()

var current_cooldown: float :
	get:
		if _cooldown <= 0:
			return _cooldown 
		return _cooldown_timer.time_left

var _cooldown_timer: Timer 
var _can_be_fired: bool = true

# Weapon charge related variables
@export_subgroup('Charged Weapon')
@export var _can_be_charged: bool = false
@export var _overcharge_reset: bool = false
@export var _charging_speed: float = 0.2
@export var _minimum_charging_time: float = 0
@export var _maximum_charging_time: float = 1
var _current_charged_time = 0


signal being_used(used: bool)
signal fired(can_be_charged: bool, current_charge: float, minimum_charging_time: float, maximum_charging_time: float)
signal charged(current_charge: float, minimum_charging_time: float, maximum_charging_time: float, overcharged: bool)


func _ready() -> void:
	# Set up cooldown timer
	if _cooldown > 0:
		_cooldown_timer = Timer.new()
		_cooldown_timer.one_shot = false
		_cooldown_timer.autostart = false
		_cooldown_timer.wait_time = _cooldown
		_cooldown_timer.timeout.connect(_on_cooldown_ended)
		_cooldown_timer.paused = true
		add_child(_cooldown_timer)
		_cooldown_timer.start()


func on_weapon_being_used(used: bool) -> void:
	being_used.emit(used)


func on_weapon_fired() -> void:
	if not _can_be_fired:
		return

	if _can_be_charged && _current_charged_time < _minimum_charging_time:
		_current_charged_time = 0

	if _cooldown > 0:
		_can_be_fired = false
		_cooldown_timer.paused = false

	fired.emit(_can_be_charged, _current_charged_time, _minimum_charging_time, _maximum_charging_time)


func on_weapon_charged(delta: float) -> void:
	if not _can_be_charged:
		print('Current weapon %s can\'t be charged', name)
		return
	
	var _overcharged = false
	_current_charged_time += delta * _charging_speed
	if _overcharge_reset && _current_charged_time > _maximum_charging_time:
		_overcharged = true
		_current_charged_time = 0
		
	charged.emit(_current_charged_time, _minimum_charging_time, _maximum_charging_time, _overcharged)


func _on_cooldown_ended() -> void:
	_cooldown_timer.paused = true
	_can_be_fired = true


func update_cooldowm() -> void:
		if _cooldown_timer:
			_cooldown_timer.wait_time = _cooldown

			# Game rule, when cooldown change, changes current cooldown
			if _cooldown_timer.time_left > _cooldown_timer.wait_time:
				_cooldown_timer.stop()
				_cooldown_timer.start()
