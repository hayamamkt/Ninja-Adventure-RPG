extends Control
class_name HeartGUI

@onready var sprite_2d: Sprite2D = $Sprite2D

#enum HEART_VAL { EMPTY, QUARTER, HALF, THREE_QUARTERS, FULL }

var value = 4:
	set(v):
		value = v
		update_heart()


func update_heart() -> void:
	sprite_2d.frame = value
