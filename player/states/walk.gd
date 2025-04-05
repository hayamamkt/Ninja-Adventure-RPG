extends PlayerState

func _enter() -> void:
	_player.apply_animation(WALK)

func _update(delta: float) -> void:
	_player.apply_movement(delta)

	if _player.change_dir():
		_player.apply_animation(WALK)

	if _player.direction == Vector2.ZERO:
		dispatch(TO_IDLE)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		dispatch(TO_ATTACK)

	#if event.is_action_pressed("interact"):
		#PlayerManager.interact_pressed.emit()
