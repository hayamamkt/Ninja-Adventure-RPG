extends PlayerState

var _attacking := false

func _enter() -> void:
	_attacking = true
	_player.weapon.monitoring = true
	_player.apply_attack()

	await get_tree().create_timer(0.4).timeout
	_attacking = false
	_player.weapon.monitoring = false
	#if _attacking:
		#_player.apply_hurt_box(true)

func _exit() -> void:
	_attacking = false
	_player.weapon.monitoring = false
	#_player.apply_hurt_box(false)
	#set_deferred(_player.hurt_box.monitoring, false)

func _update(delta: float) -> void:
	_player.apply_decelerate(delta)

	if not _attacking:
		dispatch(TO_IDLE)
