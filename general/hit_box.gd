extends Area2D
class_name HitBox

signal damaged(hurt_box: HurtBox)

func take_damage(hurt_box: HurtBox) -> void:
	print_debug(hurt_box)
	damaged.emit(hurt_box)
