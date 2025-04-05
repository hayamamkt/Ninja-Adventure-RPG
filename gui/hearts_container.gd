extends HBoxContainer

const Heart = preload("res://gui/heart_gui.tscn")

func set_max_hearts(value: int) -> void:
	for i in range(value):
		var heart = Heart.instantiate()
		add_child(heart)

func update_hearts(amount: int) -> void:
	var hearts = get_children()
	for i in range(amount):
		hearts[i].update(true)

	for i in range(amount, hearts.size()):
		hearts[i].update(false)
