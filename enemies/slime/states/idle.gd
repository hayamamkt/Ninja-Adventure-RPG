extends SlimeState

var _time: float = 0.0

func _enter() -> void:
	_time = _enemy.get_rand_duration()
	_enemy.velocity = Vector2.ZERO
	_enemy.apply_animation(IDLE)

func _update(delta: float) -> void:
	_time -= delta

	if _time <= 0:
		dispatch(TO_WALK)


func _on_hit_box_damaged(_hurt_box: HurtBox) -> void:
	dispatch(TO_STUN)
