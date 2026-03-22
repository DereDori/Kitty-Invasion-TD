# src/units/rats/rat_warrior.gd
extends Rat
class_name RatWarrior

var _target_cat: Cat = null

func update(_scaled_delta: float) -> void:
	if _target_cat == null or not _target_cat.is_alive():
		_target_cat = null
		return
	if can_attack():
		reset_attack_cooldown()
		_target_cat.take_damage(power)

func set_target(cat: Cat) -> void:
	_target_cat = cat
