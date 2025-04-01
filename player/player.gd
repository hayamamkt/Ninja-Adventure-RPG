extends CharacterBody2D
class_name Player

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT,  Vector2.UP]

@export_category("Setting")
@export var hp := 6
@export var max_hp := 6
@export var invulnerable_duration := 1.0
@export var knockback_speed := 500.0

@export_category("Movement")
@export var move_speed := 150.0

@export_category("Attack")
@export_range(1, 20, 0.5) var decelerate_speed := 15.0
@export var attack_sound: AudioStream

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var hsm: LimboHSM = $LimboHSM
@onready var idle_state: LimboState = $LimboHSM/Idle
@onready var move_state: LimboState = $LimboHSM/Walk
@onready var attack_state: LimboState = $LimboHSM/Attack
#@onready var stun_state: LimboState = $LimboHSM/Stun

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var movement_input: Vector2 = Vector2.ZERO
var invulnerable := false

func _ready() -> void:
	#PlayerManager.player = self
	_init_state_machine()

func _init_state_machine() -> void:
	hsm.add_transition(hsm.ANYSTATE, move_state, PlayerState.TO_WALK)
	hsm.add_transition(hsm.ANYSTATE, idle_state, PlayerState.TO_IDLE)
	hsm.add_transition(idle_state, attack_state, PlayerState.TO_ATTACK)
	hsm.add_transition(move_state, attack_state, PlayerState.TO_ATTACK)
	#hsm.add_transition(hsm.ANYSTATE, stun_state, PlayerState.TO_STUN)

	hsm.initial_state = idle_state
	hsm.initialize(self)
	hsm.set_active(true)

func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

func _physics_process(_delta: float) -> void:
	move_and_slide()

func apply_animation(state: String) -> void:
	animation_player.play(state + "_" + apply_dir())

func apply_movement(_delta: float) -> void:
	velocity = direction * move_speed

func apply_decelerate(delta: float) -> void:
	velocity -= velocity * decelerate_speed * delta

func apply_attack() -> void:
	apply_animation("attack")
	#splash_animation_player.play("attack_" + apply_dir())
	#audio.stream = attack_sound
	#audio.pitch_scale = randf_range(0.9, 1.1)
	#audio.play()


func apply_dir() -> String:
	if cardinal_direction == Vector2.UP: return "up"
	if cardinal_direction == Vector2.DOWN: return "down"
	if cardinal_direction == Vector2.LEFT: return "left"
	if cardinal_direction == Vector2.RIGHT: return "right"
	return "down"

func change_dir() -> bool:
	if direction == Vector2.ZERO: return false

	var dir_id = int( round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_dir = DIR_4[dir_id]

	if new_dir == cardinal_direction: return false

	cardinal_direction = new_dir
	#dir_changed.emit(new_dir)
	#sprite_2d.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1

	return true
