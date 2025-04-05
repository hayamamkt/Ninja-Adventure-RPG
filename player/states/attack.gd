extends PlayerState

var _attacking := false

func _enter() -> void:
	_attacking = true
	_player.toggle_weapon(true)
	_player.apply_attack()

func _exit() -> void:
	_attacking = false
	_player.toggle_weapon(false)

func _update(delta: float) -> void:
	_player.apply_decelerate(delta)

	if not _attacking:
		dispatch(TO_IDLE)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	_attacking = false
	_player.toggle_weapon(false)
