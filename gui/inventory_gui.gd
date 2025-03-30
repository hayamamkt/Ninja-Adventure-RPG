extends Control
class_name InventoryGUI

signal opened
signal closed

var is_open := false

func _ready() -> void:
	toggle(false)

func toggle(switch: bool) -> void:
	visible = switch
	is_open = switch
	if switch:
		opened.emit()
	else:
		closed.emit()
