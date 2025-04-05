extends PlayerState

var _damage_pos: Vector2
var _dir: Vector2
var _animation_finished := false

func _enter() -> void:
	_player.invulnerable = true
	_dir = _player.global_position.direction_to(_damage_pos)
	_player.change_dir()
	_player.efx_animation_player.play("damaged")
	_player.apply_animation(PlayerState.STUN)
	_player.velocity = _dir * -_player.knockback_speed
	_player.make_invulnerable( _player.invulnerable_duration )

func _exit() -> void:
	_player.invulnerable = false

func _update(delta: float) -> void:
	if _animation_finished:
		_player.velocity = Vector2.ZERO
		dispatch(TO_IDLE)
	_player.velocity -= _player.velocity * _player.decelerate_speed * delta * 2

func _on_player_player_damaged(hurt_box: HurtBox) -> void:
	_damage_pos = hurt_box.global_position
	dispatch(TO_STUN)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	_animation_finished = true
