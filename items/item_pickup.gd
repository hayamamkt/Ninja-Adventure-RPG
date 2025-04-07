@tool
class_name ItemPickup
extends CharacterBody2D

@export var item_data: ItemData : set = _set_item_data

signal picked_up

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	_update_texture()
	if Engine.is_editor_hint(): return

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
	velocity -= velocity * delta * 4


func item_picked_up() -> void:
	area_2d.body_entered.disconnect(_on_area_2d_body_entered)
	audio_stream_player_2d.play()
	visible = false
	picked_up.emit()
	await audio_stream_player_2d.finished
	queue_free()

func _set_item_data(value: ItemData) -> void:
	item_data = value
	_update_texture()

func _update_texture() -> void:
	if item_data == null or sprite_2d == null: return
	sprite_2d.texture = item_data.texture

####
## Signals
func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is Player and
		item_data and
		PlayerManager.INVENTORY_DATA.add_item(item_data) == true
	): item_picked_up()
