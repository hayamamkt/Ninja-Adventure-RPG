extends CharacterBody2D
class_name Enemy

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT,  Vector2.UP]
#const PICKUP = preload("res://items/item_pickup.tscn")

signal dir_changed(new_dir: Vector2)
signal enemy_damaged(hurt_box: HurtBox)
signal enemy_destroyed(hurt_box: HurtBox)

@export_category("Gernal Setting")
@export var hp := 3
@export_range(0, 99, 1) var damage := 0
@export var knockback_speed := 200.0
@export var desclerate_speed := 10.0
@export var duration_min := 0.5
@export var duration_max := 1.5
@export var animation_duration := 0.5
@export var cycle_min := 1
@export var cycle_max := 3

@export_category("Item Drop")
#@export var drops: Array[DropData]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $HitBox
@onready var efx_animation_player: AnimationPlayer = $EfxAnimationPlayer
@onready var death_animation_player: AnimationPlayer = $DeathSrite2D/DeathAnimationPlayer

@onready var hsm: LimboHSM = $LimboHSM
@onready var idle_state: LimboState = $LimboHSM/Idle
@onready var move_state: LimboState = $LimboHSM/Walk
@onready var stun_state: LimboState = $LimboHSM/Stun
@onready var destroy_state: LimboState = $LimboHSM/Destroy

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var invulnerable := false
var player: Player

func _physics_process(_delta: float) -> void:
	move_and_slide()

func apply_animation(state: String) -> void:
	var s = "4way/" + state
	animation_player.play(s + "_" + apply_dir_name())

func apply_rand_dir() -> void:
	var rnd = randi_range(0, 3)
	var _dir = DIR_4[rnd]
	change_dir(_dir)

func apply_dir_name() -> String:
	if cardinal_direction == Vector2.UP: return "up"
	if cardinal_direction == Vector2.DOWN: return "down"
	if cardinal_direction == Vector2.LEFT: return "left"
	if cardinal_direction == Vector2.RIGHT: return "right"
	return "down"

func get_rand_duration() -> float:
	return randf_range(duration_min, duration_max)

func get_rand_cycle() -> float:
	return randf_range(cycle_min, cycle_max) * animation_duration

func change_dir(dir: Vector2 = Vector2.ZERO) -> bool:
	direction = dir
	if direction == Vector2.ZERO: return false

	var dir_id = int( round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_dir = DIR_4[dir_id]

	if new_dir == cardinal_direction: return false

	cardinal_direction = new_dir
	dir_changed.emit(new_dir)

	return true

#func drop_items() -> void:
	#if drops.size() == 0: return
#
	#for i in drops.size():
		#if drops[i] == null or drops[i].item == null: continue
		#var drop_count: int = drops[i].get_drop_count()
		#for j in drop_count:
			#var drop = PICKUP.instantiate() as ItemPickup
			#drop.item_data = drops[i].item
			#get_parent().call_deferred("add_child", drop)
			#drop.global_position = global_position
			#drop.velocity = velocity.rotated(randf_range(-1.5, 1.5)) * randf_range(0.9, 1.5)

func _on_hit_box_damaged(hurt_box: HurtBox) -> void:
	if invulnerable: return

	hp -= hurt_box.damage

	if hp > 0:
		enemy_damaged.emit(hurt_box)
	else:
		enemy_destroyed.emit(hurt_box)
#
