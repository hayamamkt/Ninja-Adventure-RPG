extends CanvasLayer

@onready var inventory_gui: InventoryGUI = $MarginContainer/InventoryGUI


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_gui.toggle(!inventory_gui.is_open)
