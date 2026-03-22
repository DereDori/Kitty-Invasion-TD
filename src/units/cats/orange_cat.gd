# src/units/cats/orange_cat.gd
extends Cat
class_name OrangeCat

@export var run_away_chance: float = 0.25
var _mid_fight_timer: float = 0.0

func update(scaled_delta: float) -> void:
	_mid_fight_timer -= scaled_delta
	super.update(scaled_delta)

func on_kill_warrior(_warrior: RatWarrior) -> void:
	retreat()

func _try_attack(target: Unit) -> void:
	# Random chance to bolt mid-fight when timer expires
	if _mid_fight_timer <= 0.0 and randf() < run_away_chance:
		retreat()
		return
	_mid_fight_timer = 2.0
	super._try_attack(target)
