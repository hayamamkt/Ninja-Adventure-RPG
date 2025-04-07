@tool
extends Area2D
class_name LevelTransition

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export_file("*.tscn") var level
@export var target_transition_area := "LevelTransition"
@export var center_player := true

@export_category("Collision Area Setting")
@export_range(1, 12, 1, "or_greater") var size := 2 :
	set(v):
		size = v
		_update_area()

@export var side := SIDE.LEFT :
	set(v):
		side = v
		_update_area()

@export var snap_to_grid := false :
	set(v):
		_snap_to_grid()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint(): return

	monitoring = false
	_place_player()

	await LevelManager.level_loaded
	monitoring = true

func _update_area() -> void:
	var new_rect := Vector2(32, 32)
	var new_pos := Vector2.ZERO

	if side == SIDE.TOP:
		new_rect.x *= size
		new_pos.y -= 16
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_pos.y += 16
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_pos.x -= 16
	elif side == SIDE.RIGHT:
		new_rect.y*= size
		new_pos.x += 16

	if collision_shape_2d == null:
		collision_shape_2d = get_node("CollisionShape2D")

	collision_shape_2d.shape.size = new_rect
	collision_shape_2d.position = new_pos


func _snap_to_grid() -> void:
	position.x = round(position.x / 16) * 16
	position.y = round(position.y / 16) * 16

func _place_player() -> void:
	if name != LevelManager.target_transition: return

	PlayerManager.set_player_position(global_position + LevelManager.position_offset)

func _get_offset() -> Vector2:
	var offset := Vector2.ZERO
	var pos := PlayerManager.player.global_position

	if side == SIDE.LEFT or side == SIDE.RIGHT:
		offset.y = 0.0 if center_player else pos.y - global_position.y
		offset.x = 16
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		offset.x = 0.0 if center_player else pos.x - global_position.x
		offset.y = 16
		if side == SIDE.TOP:
			offset.y *= -1

	return offset

func _on_body_entered(_body: Node2D) -> void:
	LevelManager.load_new_level(level, target_transition_area, _get_offset())
