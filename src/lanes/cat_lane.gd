# src/lanes/cat_lane.gd
extends Node2D
class_name CatLane

const MELEE_RANGE: float = 48.0

@export var lane_length: float = 960.0

@onready var spawn_point: Marker2D = $Markers/SpawnPoint
@onready var lane_end: Marker2D    = $Markers/LaneEnd
@onready var units_container: Node2D = $Units

var _cats: Array[Cat]         = []
var _warriors: Array[RatWarrior] = []

# ── Spawning ──────────────────────────────────────────────

func spawn_cat(cat_scene: PackedScene) -> Cat:
	var cat: Cat = cat_scene.instantiate()
	cat.position = spawn_point.position
	cat.lane = self
	units_container.add_child(cat)
	_cats.append(cat)
	cat.died.connect(_on_unit_died.bind(cat))
	return cat

func place_warrior(warrior_scene: PackedScene, x_pos: float) -> RatWarrior:
	var warrior: RatWarrior = warrior_scene.instantiate()
	warrior.position = Vector2(x_pos, 0.0)
	units_container.add_child(warrior)
	_warriors.append(warrior)
	warrior.died.connect(_on_unit_died.bind(warrior))
	return warrior

# ── Per-frame logic ───────────────────────────────────────

func _physics_process(_delta: float) -> void:
	_resolve_melee()

func _resolve_melee() -> void:
	for cat in _cats:
		if not cat.is_alive():
			continue
		var target = _get_warrior_in_range(cat)
		if target:
			cat.set_melee_target(target)
			target.set_target(cat)
		else:
			cat.set_melee_target(null)

func _get_warrior_in_range(cat: Cat) -> RatWarrior:
	for warrior in _warriors:
		if not warrior.is_alive():
			continue
		if abs(warrior.position.x - cat.position.x) <= MELEE_RANGE:
			return warrior
	return null

# ── Death handling ────────────────────────────────────────

func _on_unit_died(unit: Unit) -> void:
	if unit is Cat:
		_cats.erase(unit)
	elif unit is RatWarrior:
		var warrior = unit as RatWarrior
		# find the cat that killed it and trigger retreat
		var killer = _get_nearest_cat(warrior.position.x)
		if killer:
			killer.on_kill_warrior(warrior)
		_warriors.erase(warrior)

func _get_nearest_cat(x_pos: float) -> Cat:
	var closest: Cat = null
	var closest_dist: float = INF
	for cat in _cats:
		if not cat.is_alive():
			continue
		var d = abs(cat.position.x - x_pos)
		if d < closest_dist:
			closest_dist = d
			closest = cat
	return closest

# ── Queries ───────────────────────────────────────────────

func has_living_cats() -> bool:
	return _cats.any(func(c): return c.is_alive())

func has_living_warriors() -> bool:
	return _warriors.any(func(w): return w.is_alive())
