class_name InventorySlotUI
extends Button

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

var slot_data: SlotData : set = set_slot_data

func _ready() -> void:
	texture_rect.texture = null
	label.text = ""
	#focus_entered.connect(_on_item_focused)
	#focus_exited.connect(_on_item_unfocused)

func set_slot_data(value: SlotData) -> void:
	slot_data = value
	if slot_data == null: return
	texture_rect.texture = value.item_data.texture
	label.text = str(value.quantity)


#region Signals Connects
func _on_item_focused():
	if slot_data == null or slot_data.item_data == null: return
	PauseMenu.update_item_desc(slot_data.item_data.desccriptio)

func _on_item_unfocused():
	PauseMenu.update_item_desc("")

func _on_pressed() -> void:
	if slot_data == null or slot_data.item_data == null: return
	var was_used = slot_data.item_data.use()
	if not was_used: return

	slot_data.quantity -= 1
	label.text = str(slot_data.quantity)
#endregion
