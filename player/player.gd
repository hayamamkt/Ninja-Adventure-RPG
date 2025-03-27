extends CharacterBody2D
class_name Player

@export var ground_tilemap: TileMapLayer
@export var move_speed := 100.0

@onready var camera_2d: Camera2D = $Camera2D
@onready var animation_tree: AnimationTree = $AnimationTree

var direction := Vector2.ZERO
var last_facing := Vector2.ZERO

func _ready() -> void:
	_setup_camera_limits()


func _process(_delta: float) -> void:
	direction = Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down"
	).normalized()
	update_animate_param()

func _physics_process(_delta: float) -> void:
	velocity = direction * move_speed
	move_and_slide()

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

#func _handle_collision() -> void:
	#for i in get_slide_collision_count():
		#var collision = get_slide_collision(i)


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.name == "HitBox":
		print_debug(area.get_parent().name)
