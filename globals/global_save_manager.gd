extends Node

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var filename := SAVE_PATH + "data.sav"

var current_save: Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0,
	},
	items = [],
	persistence = [],
	quests = [],
}

func has_saving_file() -> bool:
	return FileAccess.file_exists(filename)

func save_game() -> void:
	_update_player_data()
	_update_scene_path()
	_update_item_data()
	var file := FileAccess.open(filename, FileAccess.WRITE)
	var svae_json = JSON.stringify(current_save)
	file.store_line(svae_json)
	game_saved.emit()

func load_game() -> void:
	var file := FileAccess.open(filename, FileAccess.READ)
	var json := JSON.new()
	json.parse(file.get_line())
	var dict := json.get_data() as Dictionary
	current_save = dict

	LevelManager.load_new_level(current_save.scene_path)

	await LevelManager.level_load_started

	PlayerManager.set_player_position(Vector2(
		current_save.player.pos_x,
		current_save.player.pos_y
	))
	PlayerManager.set_health(
		current_save.player.hp,
		current_save.player.max_hp
	)
	PlayerManager.INVENTORY_DATA.parse_save_data(current_save.items)

	await LevelManager.level_loaded

	game_loaded.emit()

func _update_player_data() -> void:
	var p := PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y

func _update_scene_path() -> void:
	var p := ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p

func _update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()

func add_persistence_value(value: String) -> void:
	if check_persistent_value(value) == false:
		current_save.persistence.append(value)

func check_persistent_value(value: String) -> bool:
	var p = current_save.persistence as Array
	return p.has(value)
