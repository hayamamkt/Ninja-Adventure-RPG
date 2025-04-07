extends GridContainer
class_name InventoryUI

const INVENTORY_SLOT = preload("res://inventory/inventory_slot.tscn")

@export var data: InventoryData

var focus_index := 0

func _ready() -> void:
	PauseMenu.shown.connect(update_inventory)
	PauseMenu.hidden.connect(clear_inventory)
	clear_inventory()
	data.changed.connect(_on_inventory_changed)

func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()

func update_inventory(i: int = 0) -> void:
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
		new_slot.focus_entered.connect(_on_item_focus)
	await get_tree().process_frame
	get_child(i).grab_focus()


func _on_inventory_changed() -> void:
	var i = focus_index
	clear_inventory()
	update_inventory(i)


func _on_item_focus() -> void:
	for i in get_child_count():
		if get_child(i).has_focus():
			focus_index = i
			return
