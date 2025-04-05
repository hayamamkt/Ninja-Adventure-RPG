extends Resource
class_name Inventory

signal updated

@export var slots: Array[InventorySlot]

func insert(item: InventoryItem) -> void:
	var itemSlots: Array[InventorySlot] = slots.filter(func(slot): return slot.item == item)
	if itemSlots.is_empty():
		var emptySlots: Array[InventorySlot] = slots.filter(func(slot): return slot.item == null)
		if not emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
	else:
		itemSlots[0].amount += 1

	updated.emit()
