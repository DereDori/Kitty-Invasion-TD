# src/units/cats/standard_cat.gd
extends Cat
class_name StandardCat

func on_kill_warrior(_warrior: RatWarrior) -> void:
	retreat()
