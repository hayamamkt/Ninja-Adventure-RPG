extends CharacterBody2D

@export var speed := 5.0
@export var limit := 0.5
@export var end_point: Marker2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var start_pos
var end_pos

func _ready() -> void:
	start_pos = position
	end_pos = end_point.global_position

func _physics_process(_delta: float) -> void:
	update_velocity()
	move_and_slide()
	update_animation()

func update_animation() -> void:
	if velocity.length() == 0:
		if animation_player.is_playing():
			animation_player.stop()
	else:
		var dir = "down"
		if velocity.x < 0: dir = "left"
		elif velocity.x > 0: dir = "right"
		elif velocity.y < 0: dir = "up"

		animation_player.play("move_" + dir)

func change_direction() -> void:
	var temp = end_pos
	end_pos = start_pos
	start_pos = temp

func update_velocity() -> void:
	var move_dir = (end_pos - position)
	if move_dir.length() < limit:
		change_direction()

	velocity = move_dir.normalized() * speed


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area == $HitBox: return
	print_debug(area)
