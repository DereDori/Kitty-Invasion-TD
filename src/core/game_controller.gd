# src/core/game_controller.gd
extends Node

signal cat_spawned(cat, lane)
signal rat_died(rat)
signal cat_died(cat)
signal level_won
signal level_lost

var selected_cat_id: String = ""

func select_cat(cat_id: String) -> void:
	selected_cat_id = cat_id

func deselect_cat() -> void:
	selected_cat_id = ""

func on_rat_died(rat) -> void:
	rat_died.emit(rat)

func on_cat_died(cat) -> void:
	cat_died.emit(cat)
