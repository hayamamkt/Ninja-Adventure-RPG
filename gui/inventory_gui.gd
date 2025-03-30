extends Control
class_name InventoryGUI

const InventoryClass = preload("res://player/player_inventory.tres")

signal opened
signal closed

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open := false

func _ready() -> void:
	InventoryClass.updated.connect(update)
	toggle(false)
	update()

func update() -> void:
	for i in range(min(InventoryClass.items.size(), slots.size())):
		slots[i].update(InventoryClass.items[i])

func toggle(switch: bool) -> void:
	visible = switch
	is_open = switch
	if switch:
		opened.emit()
	else:
		closed.emit()
