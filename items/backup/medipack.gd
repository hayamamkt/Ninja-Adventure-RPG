extends CollectableItem

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func collect(inventory: Inventory) -> void:
	animation_player.play("spin")
	await animation_player.animation_finished
	super.collect(inventory)
