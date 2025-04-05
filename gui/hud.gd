extends CanvasLayer
###
## $Hud.layer = 2
## $Hud/$Control.mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
##

enum HeartType { FULL, HALF, QUARTER }

@onready var h_flow_container: HFlowContainer = %HFlowContainer
#@onready var version: Label = %Version

var hearts: Array[HeartGUI] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#version.text = "ver " + GameTitle.VERSION
	for child in h_flow_container.get_children():
		if child is HeartGUI:
			hearts.append(child)
			child.visible = false

func update_hp(hp: int, max_hp: int, type: HeartType = HeartType.QUARTER) -> void:
	_update_max_hp(max_hp, type)
	for i in max_hp:
		_update_heart(i, hp, type)

func _update_heart(index: int, hp: int, type: HeartType) -> void:
	var q: float = _count_hearts(type)
	var v = clampf(hp - index * q, 0, q)
	hearts[index].value = v

func _update_max_hp(max_hp: int, type: HeartType)-> void:
	var q: float = _count_hearts(type)
	var heart_count = roundi( max_hp / q)
	for i in hearts.size():
		hearts[i].visible = true if i < heart_count else false

func _count_hearts(type: HeartType) -> float:
	if type == HeartType.HALF: return 2.0
	if type == HeartType.QUARTER: return 4.0
	return 1.0
