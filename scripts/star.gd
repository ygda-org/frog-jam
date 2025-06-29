extends Node2D

var random = RandomNumberGenerator.new()

var sprites = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(1, 11):
		sprites.append(load("res://assets/images/star-" + str(i) + ".png"))
	var chosen = random.randi_range(0, 9)
	$Sprite2D.texture = sprites[chosen]


func _on_visible_on_screen_notifier_2d_screen_exited():
	position.x = (DisplayServer.screen_get_size().x / -2)-150
