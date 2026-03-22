# src/core/player_inventory.gd
extends Node

# key: cat definition id (String), value: count (int)
var cat_counts: Dictionary = {}
var catnip: int = 0

func add_cat(cat_id: String, qty: int = 1) -> void:
	cat_counts[cat_id] = cat_counts.get(cat_id, 0) + qty

func remove_cat(cat_id: String) -> bool:
	if cat_counts.get(cat_id, 0) <= 0:
		return false
	cat_counts[cat_id] -= 1
	return true

func has_cats() -> bool:
	for id in cat_counts:
		if cat_counts[id] > 0:
			return true
	return false

func add_catnip(amount: int) -> void:
	catnip += amount

func spend_catnip(amount: int) -> bool:
	if catnip < amount:
		return false
	catnip -= amount
	return true

func reset_catnip() -> void:
	catnip = 0
