extends Panel

@onready var background: Sprite2D = $Background
@onready var item: Sprite2D = $CenterContainer/Panel/Item

func update(t: InventoryItem) -> void:
	if t:
		item.visible = true
		item.texture = t.texture
	else:
		item.visible = false
