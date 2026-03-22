# src/units/unit.gd
extends CharacterBody2D
class_name Unit

signal died(unit)

@export var max_health: float = 100.0
@export var power: float     = 10.0
@export var attack_speed: float = 1.0  # attacks per second

var health: float
var _attack_cooldown: float = 0.0
var _is_dead: bool = false

func _ready() -> void:
	health = max_health

func _physics_process(delta: float) -> void:
	if _is_dead:
		return
	var scaled = delta * SpeedController.get_multiplier()
	_attack_cooldown -= scaled
	update(scaled)

# Override in subclasses
func update(_scaled_delta: float) -> void:
	pass

func take_damage(amount: float) -> void:
	if _is_dead:
		return
	health -= amount
	if health <= 0.0:
		health = 0.0
		_die()

func is_alive() -> bool:
	return not _is_dead

func can_attack() -> bool:
	return _attack_cooldown <= 0.0

func reset_attack_cooldown() -> void:
	_attack_cooldown = 1.0 / attack_speed

func _die() -> void:
	_is_dead = true
	died.emit(self)
	on_death()

# Override in subclasses
func on_death() -> void:
	queue_free()
