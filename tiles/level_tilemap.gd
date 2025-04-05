extends Node2D
class_name LevelTileMap

@export var	tilemap: TileMapLayer

func _ready():
	LevelManager.change_tilemap_bounds(get_tilemap_bounds())

func get_tilemap_bounds() -> Array[Vector2]:
	var tile_size := tilemap.rendering_quadrant_size

	if tilemap:
		tile_size = tilemap.tile_set.tile_size.x

	var b: Array[Vector2] = []
	b.append(Vector2(
		tilemap.get_used_rect().position * tile_size
	))
	b.append(Vector2(
		tilemap.get_used_rect().end * tile_size
	))
	return b
