extends Node

const PLAYER = preload("res://player/player.tscn")
#const INVENTORY_DATA : InventoryData = preload("res://GUI/pause_menu/inventory/player_inventory.tres")

#signal camera_shook( trauma : float )
#signal interact_pressed
#signal player_leveled_up

#var interact_handled : bool = true
var player : Player
var player_spawned : bool = false

#var level_requirements = [ 0, 50, 100, 200, 400, 800, 1500, 3000, 6000, 12000, 2500 ]
#var level_requirements = [ 0, 5, 10, 20, 40 ]


func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true

func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child( player )


func set_health(hp: int, max_hp: int) -> void:
	player.max_hp = max_hp
	player.hp = hp if hp <= player.max_hp else player.max_hp
	player.update_hp(0)

func set_as_parent(node: Node2D):
	if player.get_parent():
		player.get_parent().remove_child(player)
	node.add_child(player)

func set_player_position(new_pos: Vector2) -> void:
	print("PlayerMangge: set_player_position=", new_pos)
	player.global_position = new_pos
	player.velocity = Vector2.ZERO

func unparent_player(node: Node2D):
	node.remove_child(player)
