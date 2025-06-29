class_name FrogBubble
extends Area2D

@export var frog_data: FrogData

var random = RandomNumberGenerator.new()

func _ready():
	if random.randi_range(0, 1) == 1:
		scale.x *= -1

func set_data(new_data: FrogData) -> void:
	self.frog_data = new_data
	$FrogSprite.texture = new_data.texture

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	(body as Player).collect_frog(frog_data)
	self.queue_free()
