extends Node2D

var weapon: Area2D

func _ready() -> void:
	if get_children().is_empty(): return

	weapon = get_children()[0].get_child(0)
	weapon.monitorable = false
	print_debug(weapon)

func enable() -> void:
	if not weapon: return
	visible = true
	weapon.monitoring = true

func disable() -> void:
	if not weapon: return
	visible = false
	weapon.monitoring = false
