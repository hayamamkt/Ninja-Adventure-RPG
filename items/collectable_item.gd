extends Area2D
class_name CollectableItem

@export var item_res: InventoryItem

func collect(inventory: Inventory) -> void:
	inventory.insert(item_res)
	queue_free()
