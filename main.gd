# src/main.gd  — temporary test harness, replaced in Phase 2
extends Node2D

@export var cat_scene: PackedScene
@export var warrior_scene: PackedScene

@onready var cat_lane: CatLane = $CatLane

func _ready() -> void:
	# place one warrior mid-lane
	cat_lane.place_warrior(warrior_scene, 480.0)
	# give player one cat to start
	PlayerInventory.add_cat("black_slim", 1)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("click detected, button: ", event.button_index)
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("inventory count: ", PlayerInventory.cat_counts)
			if PlayerInventory.remove_cat("black_slim"):
				print("spawning cat")
				cat_lane.spawn_cat(cat_scene)
			else:
				print("no cats in inventory")
