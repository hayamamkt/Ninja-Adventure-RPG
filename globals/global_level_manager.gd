extends Node

signal tilemap_bounds_changed(bounds: Array[Vector2])
signal level_load_started
signal level_loaded

var current_tilemap_bounds: Array[Vector2]
var target_transition: String
var position_offset: Vector2

func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()

func change_tilemap_bounds(bounds: Array[Vector2]):
	current_tilemap_bounds = bounds
	tilemap_bounds_changed.emit(bounds)

func load_new_level(
	level_path: String,
	transition: String = "",
	offset: Vector2 = Vector2.ZERO
) -> void:
	get_tree().paused = true
	target_transition = transition
	position_offset = offset

	await SceneTransition.fade(SceneTransition.OUT)
	level_load_started.emit()

	await get_tree().process_frame
	get_tree().change_scene_to_file(level_path)

	await SceneTransition.fade(SceneTransition.IN)
	get_tree().paused = false

	await get_tree().process_frame
	level_loaded.emit()
