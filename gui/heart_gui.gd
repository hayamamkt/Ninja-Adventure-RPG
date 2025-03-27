extends Panel

@onready var sprite_2d: Sprite2D = $Sprite2D

func update(whole: bool) -> void:
	if whole: sprite_2d.frame = 4
	else: sprite_2d.frame = 0
