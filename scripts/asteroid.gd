extends RigidBody2D
const ASTEROID_1 = preload("res://assets/images/Asteroid 1.png")
const ASTEROID_2 = preload("res://assets/images/Asteroid 2.png")
const ASTEROID_3 = preload("res://assets/images/Asteroid 3.png")
const ASTEROID_4 = preload("res://assets/images/Asteroid 4.png")

var textures = [ASTEROID_1, ASTEROID_2, ASTEROID_3, ASTEROID_4]

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite = textures[random.randi_range(0,3)]
	$Sprite2D.texture = sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
