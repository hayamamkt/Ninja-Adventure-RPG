extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer

enum { IN, OUT }

func fade(type: int) -> bool:
	var t := "fade_out" if type == OUT else "fade_in"
	animation_player.play(t)
	await animation_player.animation_finished
	return true
