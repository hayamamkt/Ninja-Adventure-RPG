extends CharacterBody2D
class_name Player

@export var move_speed := 100.0

@onready var animation_tree: AnimationTree = $AnimationTree

var direction := Vector2.ZERO
var last_facing := Vector2.ZERO

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
