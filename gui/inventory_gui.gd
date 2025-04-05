extends Control
class_name InventoryGUI


signal opened
signal closed

@onready var inventory: Inventory = preload("res://player/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open := false

func _ready() -> void:
	inventory.updated.connect(update)
	toggle(false)
	update()

func update() -> void:
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

func toggle(switch: bool) -> void:
	visible = switch
	is_open = switch
	if switch:
		opened.emit()
	else:
		closed.emit()
