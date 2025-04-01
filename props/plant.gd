extends Node2D


func _on_hit_box_damaged(hurt_box: HurtBox) -> void:
	print_debug("name=", name, hurt_box)
	queue_free()
