extends Node2D

const SPEED = 200

var sprites = [preload("res://assets/images/clod1.PNG"), preload("res://assets/images/clod2.PNG"), preload("res://assets/images/clod3.PNG")]

var random = RandomNumberGenerator.new()

func _ready():
	var chosen = random.randi_range(0,2)
	$Sprite2D.texture = sprites[chosen]

func _process(delta):
	position.x += SPEED * delta
