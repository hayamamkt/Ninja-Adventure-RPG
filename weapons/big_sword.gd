extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func enable() -> void:
	collision_shape_2d.disabled = false

func disable() -> void:
	collision_shape_2d.disabled = true
