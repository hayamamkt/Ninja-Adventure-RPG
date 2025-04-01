extends LimboState
class_name PlayerState

const IDLE = "idle"
const WALK = "walk"
const STUN = "stun"
const ATTACK = "attack"
const TO_IDLE = "to_idle"
const TO_WALK = "to_walk"
const TO_ATTACK = "to_attack"
const TO_STUN = "to_stun"

var _player: Player

func _setup() -> void:
	_player = agent
