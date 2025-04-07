extends Resource
class_name ItemData

@export var name := ""
@export_multiline var desccriptio := ""
@export var texture: Texture2D

@export_category("Item Use Effects")
@export var effects: Array[ItemEffect]

func use() -> bool:
	if effects.size() == 0: return false

	for e in effects:
		if e: e.use()

	return true
