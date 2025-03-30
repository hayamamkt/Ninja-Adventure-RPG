extends Node2D

@onready var hearts_container: HBoxContainer = $CanvasLayer/MarginContainer/HeartsContainer
@onready var player: Player = $Player


func _ready() -> void:
	hearts_container.set_max_hearts(player.max_hp)
	hearts_container.update_hearts(player.hp)
	player.health_changed.connect(hearts_container.update_hearts)


func _on_inventory_gui_opened() -> void:
	get_tree().paused = true


func _on_inventory_gui_closed() -> void:
	get_tree().paused = false
