extends Node2D

var weapon: Area2D

func _ready() -> void:
	if get_children().is_empty(): return

	weapon = get_children()[0]

func enable() -> void:
	if not weapon: return
	visible = true
	weapon.enable()

func disable() -> void:
	if not weapon: return
	visible = false
	weapon.disable()
