extends Node2D

class_name Base_Enemy

@onready var parent : CharacterBody2D = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node):
	if body is Player:
		(body as Player).enemy_collision(self)

func suicide():
	call_deferred("queue_free")
