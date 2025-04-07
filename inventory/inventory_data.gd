class_name InventoryData
extends Resource

@export var slots: Array[SlotData]

func _init() -> void:
	connect_slots()

func add_item(item: ItemData, count: int = 1) -> bool:
	for s in slots:
		if s == null or s.item_data != item: continue
		s.quantity += count
		return true

	for i in slots.size():
		if slots[i] != null: continue
		var slot = SlotData.new()
		slot.item_data = item
		slot.quantity = count
		slot.changed.connect(_on_slot_changed)
		slots[i] = slot
		return true

	return false

func connect_slots() -> void:
	for s in slots:
		if s :
			s.changed.connect(_on_slot_changed)

func _on_slot_changed() -> void:
	for s in slots:
		if s and s.quantity < 1:
			s.changed.disconnect(_on_slot_changed)
			var idx = slots.find(s)
			slots[idx] = null
			emit_changed()

func get_save_data() -> Array:
	var item_save: Array = []
	for i in slots.size():
		item_save.append(item_to_save(slots[i]))
	return item_save

func item_to_save(slot: SlotData) -> Dictionary:
	var result = { item = "", quantity = 0 }
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
	return result


func parse_save_data(save_data: Array) -> void:
	var array_size = slots.size()
	slots.clear()
	slots.resize(array_size)
	for i in save_data.size():
		slots[i] = item_form_save(save_data[i])
	connect_slots()

func item_form_save(save_obj: Dictionary) -> SlotData:
	if save_obj.item == "": return null
	var new_slot := SlotData.new()
	new_slot.item_data = load(save_obj.item)
	new_slot.quantity = int(save_obj.quantity)
	return new_slot

func use_item(item: ItemData, count: int = 1) -> bool:
	for s in slots:
		if s and s.item_data == item and s.quantity >= count:
			s.quantity -= count
			return true

	return false
