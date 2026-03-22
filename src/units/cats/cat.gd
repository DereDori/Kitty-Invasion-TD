# src/units/cats/cat.gd
extends Unit
class_name Cat

@export var move_speed: float = 80.0

var lane = null          # reference to the CatLane this cat belongs to
var _retreating: bool = false

func update(scaled_delta: float) -> void:
	if _retreating:
		_do_retreat(scaled_delta)
		return

	var target = _get_melee_target()
	if target:
		_try_attack(target)
	else:
		_walk_forward(scaled_delta)

	if _is_past_lane_end():
		queue_free()

func _walk_forward(scaled_delta: float) -> void:
	position.x += move_speed * scaled_delta

func _try_attack(target: Unit) -> void:
	if not can_attack():
		return
	reset_attack_cooldown()
	target.take_damage(power)

func retreat() -> void:
	_retreating = true

func _do_retreat(scaled_delta: float) -> void:
	position.x -= move_speed * scaled_delta
	if position.x <= 0.0:
		queue_free()

var _melee_target: Unit = null

func set_melee_target(target: Unit) -> void:
	_melee_target = target

func _get_melee_target() -> Unit:
	if _melee_target != null and _melee_target.is_alive():
		return _melee_target
	return null

func _is_past_lane_end() -> bool:
	if lane == null:
		return false
	return position.x >= lane.lane_length

func on_death() -> void:
	GameController.on_cat_died(self)
	queue_free()
# add this to cat.gd
func on_kill_warrior(_warrior: RatWarrior) -> void:
	pass  # overridden by StandardCat and OrangeCat
