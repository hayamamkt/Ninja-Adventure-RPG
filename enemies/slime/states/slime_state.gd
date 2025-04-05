extends EnemyState
class_name SlimeState

var _enemy: Slime

func _setup() -> void:
	_enemy = agent as Slime
