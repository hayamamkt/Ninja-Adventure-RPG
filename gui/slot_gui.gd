extends Panel

@onready var background: Sprite2D = $Background
@onready var item: Sprite2D = $CenterContainer/Panel/Item
@onready var label: Label = $CenterContainer/Panel/Label

func update(slot: InventorySlot) -> void:
	if slot.item:
		item.visible = true
		item.texture = slot.item.texture
		label.text = str(slot.amount)
		label.visible = true
	else:
		item.visible = false
		label.visible = false
