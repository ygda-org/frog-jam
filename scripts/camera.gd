extends Camera2D

@export var player: Player

func _process(delta):
	self.global_position.y = self.player.global_position.y
