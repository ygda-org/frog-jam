extends Node2D

class_name Base_Enemy

@export var parent : RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent.body_entered.connect(_on_body_entered.bind(Node))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node):
	if body is Player:
		(body as Player).enemy_collision(self)
