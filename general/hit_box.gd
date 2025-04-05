extends Area2D
class_name HitBox

signal damaged(hurt_box: HurtBox)

func take_damage(hurt_box: HurtBox) -> void:
	damaged.emit(hurt_box)
