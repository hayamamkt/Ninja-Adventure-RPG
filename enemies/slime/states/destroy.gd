extends SlimeState

var _dir: Vector2
var _damage_position: Vector2

func _enter() -> void:
	_dir = _enemy.global_position.direction_to(_damage_position)
	_enemy.velocity = _dir * -_enemy.knockback_speed
	_enemy.apply_animation(DESTROY)
	_disable_hurt_box()
	#_enemy.drop_items()

func _update(delta) -> void:
	_enemy.velocity -= _enemy.velocity * _enemy.desclerate_speed * delta

func _disable_hurt_box() -> void:
	var hurt_box: HurtBox = _enemy.get_node_or_null("HurtBox")
	if hurt_box:
		hurt_box.monitoring = false

func _on_slime_enemy_destroyed(hunt_box: HurtBox) -> void:
	_damage_position = hunt_box.global_position
	dispatch(TO_DESTROY)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if _enemy.hp <= 0:
		_enemy.queue_free()
