class_name FrogBubble
extends Area2D

@export var frog_data: FrogData

func set_data(new_data: FrogData) -> void:
	self.frog_data = new_data

func _on_body_entered(body: Node2D) -> void:
	(body as Player).apply_powerup(frog_data.powerup)
	self.queue_free()
