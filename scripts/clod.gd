extends Node2D

var SPEED = randi_range(100,300)

var sprites = [preload("res://assets/images/clod1.PNG"), preload("res://assets/images/clod2.PNG"), preload("res://assets/images/clod3.PNG")]

var random = RandomNumberGenerator.new()

func _ready():
	var chosen = random.randi_range(0,2)
	$Sprite2D.texture = sprites[chosen]

func _process(delta):
	position.x += SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	position.x = (DisplayServer.screen_get_size().x / -2)-150
	print(position.x)
