extends CharacterBody2D

var random = RandomNumberGenerator.new()

var behavior # does it act like sputnik or shuttle, 0 for sputnik 1 for shuttle
# Called when the node enters the scene tree for the first time.
func _ready():
	behavior = random.randi_range(0, 1)
	if behavior == 0:
		$Sprite2D.texture = load("res://assets/images/Spacecraft 1.PNG")
		scale = Vector2(0.2, 0.2)
		$Collision2.disabled = false
	elif behavior == 1:
		$Sprite2D.texture = load("res://assets/images/Spacecraft 2.PNG")
		scale = Vector2(0.5, 0.5)
		$Collision1.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
