# src/units/rats/rat.gd
extends Unit
class_name Rat

@export var catnip_reward: int = 5

func on_death() -> void:
	GameController.on_rat_died(self)
	PlayerInventory.add_catnip(catnip_reward)
	queue_free()
