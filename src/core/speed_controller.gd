# src/core/speed_controller.gd
extends Node

enum Speed { NORMAL, FAST, VERY_FAST }

const MULTIPLIERS = {
	Speed.NORMAL:    1.0,
	Speed.FAST:      1.5,
	Speed.VERY_FAST: 2.0,
}

var current_speed: Speed = Speed.NORMAL

func get_multiplier() -> float:
	return MULTIPLIERS[current_speed]

func cycle() -> void:
	current_speed = ((current_speed + 1) % 3) as Speed
