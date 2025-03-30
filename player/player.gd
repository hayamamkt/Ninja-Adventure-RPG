extends CharacterBody2D
class_name Player


signal health_changed(amount: int)

@export var ground_tilemap: TileMapLayer
@export var move_speed := 100.0
@export_range(1, 6, 1) var max_hp := 3
@export var knockback_power := 800
@export var inventory: Inventory

@onready var camera_2d: Camera2D = $Camera2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var efx_animation_player: AnimationPlayer = $AnimatedSprite2D/EfxAnimationPlayer
@onready var hurt_timer: Timer = $HurtTimer
@onready var hurt_box: HurtBox = $HurtBox

@onready var hp: int = max_hp

var direction := Vector2.ZERO
var last_facing := Vector2.ZERO
var is_hurt := false

func _ready() -> void:
	_setup_camera_limits()
	efx_animation_player.play("RESET")


func _process(_delta: float) -> void:
	direction = Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down"
	).normalized()
	update_animate_param()

func _physics_process(_delta: float) -> void:
	velocity = direction * move_speed
	move_and_slide()

	if is_hurt: return

	for area in hurt_box.get_overlapping_areas():
		if not area is HitBox: continue
		hurt_by_enemy(area)

func update_animate_param() -> void:
	var idle := !velocity

	animation_tree.set("parameters/conditions/idling", idle)
	animation_tree.set("parameters/conditions/walking", !idle)

	if !idle:
		last_facing = velocity.normalized()

	animation_tree.set("parameters/Idle/blend_position", last_facing)
	animation_tree.set("parameters/Walk/blend_position", last_facing)
	animation_tree.set("parameters/Attack/blend_position", last_facing)

	if Input.is_action_just_pressed("attack"):
		animation_tree.set("parameters/conditions/attacking", true)
	else:
		animation_tree.set("parameters/conditions/attacking", false)

func _setup_camera_limits():
	var map_rect = ground_tilemap.get_used_rect()
	var tile_size = ground_tilemap.rendering_quadrant_size
	var size_pixels = map_rect.size * tile_size
	camera_2d.limit_left = 0
	camera_2d.limit_top = 0
	camera_2d.limit_right = size_pixels.x
	camera_2d.limit_bottom = size_pixels.y

func knockback(enemy_velocity: Vector2) -> void:
	var knockback_dir = (enemy_velocity - velocity).normalized() * knockback_power
	velocity = knockback_dir
	move_and_slide()

func hurt_by_enemy(area: Area2D) -> void:
	hp -= 1
	if hp <= 0: hp = max_hp

	health_changed.emit(hp)
	is_hurt = true
	knockback(area.get_parent().velocity)
	efx_animation_player.play("hurt_blink")
	hurt_timer.start()
	await hurt_timer.timeout
	efx_animation_player.play("RESET")
	is_hurt = false

#region Signals
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.has_method("collect"):
		area.collect(inventory)
#
#func _on_hurt_box_area_exited(area: Area2D) -> void:
	#enemy_collisions.erase(area)

#endregion
