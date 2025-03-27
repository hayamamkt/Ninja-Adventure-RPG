extends Node

@export var dimensions := Vector2i(7, 5)
@export var start_position := Vector2i(-1, -1)
@export var critical_path_length := 13
@export var branches := 3
@export var branch_length := Vector2i(1, 4)

var dungeon: Array
var branch_candidates: Array[Vector2i]

func _ready() -> void:
	_init_dungeon()
	_place_entrance()
	_generate_path(start_position, critical_path_length, "C")
	_generate_branches()
	print_dungeon()

func _init_dungeon() -> void:
	for x in dimensions.x:
		dungeon.append([])
		for y in dimensions.y:
			dungeon[x].append(0)

func _place_entrance() -> void:
	if start_position.x < 0 or start_position.x > dimensions.x:
		start_position.x = randi_range(0, dimensions.x - 1)

	if start_position.y < 0 or start_position.y > dimensions.y:
		start_position.y = randi_range(0, dimensions.y - 1)

	dungeon[start_position.x][start_position.y] = "S"

func _generate_path(from: Vector2i, length: int, masker: String) -> bool:
	if length == 0: return true

	var dir: Vector2i
	match randi_range(0, 3):
		0: dir = Vector2i.UP
		1: dir = Vector2i.RIGHT
		2: dir = Vector2i.DOWN
		3: dir = Vector2i.LEFT

	for i in 4:
		if (
			from.x + dir.x >= 0 and from.x + dir.x < dimensions.x and
			from.y + dir.y >= 0 and from.y + dir.y < dimensions.y and
			not dungeon[from.x + dir.x][from.y + dir.y]
		):
			from += dir
			dungeon[from.x][from.y] = length
			if length > 1:
				branch_candidates.append(from)

			if _generate_path(from, length - 1, masker ):
				return true
			else:
				branch_candidates.erase(from)
				dungeon[from.x][from.y] = 0
				from -= dir
		dir = Vector2(dir.y, -dir.x)
	return false

func _generate_branches() -> void:
	var branch_created := 0
	var candidate: Vector2i

	while branch_created < branches and branch_candidates.size():
		candidate = branch_candidates[randi_range(0, branch_candidates.size() - 1)]
		if _generate_path(candidate, randi_range(branch_length.x, branch_length.y), str(branch_created + 1)):
			branch_created += 1
		else:
			branch_candidates.erase(candidate)


func print_dungeon() -> void:
	var dungeon_as_str := ""
	for y in range(dimensions.y - 1, -1, -1):
		for x in dimensions.x:
			if dungeon[x][y]:
				dungeon_as_str += "["+ str(dungeon[x][y]) +"]"
				#dungeon_as_str += "[C]"
			else:
				dungeon_as_str += "    "
		dungeon_as_str += '\n'
	print(dungeon_as_str)
