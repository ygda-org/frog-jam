extends CharacterBody2D

var textures = [preload("res://assets/images/Asteroid 1.png"), preload("res://assets/images/Asteroid 2.png"), preload("res://assets/images/Asteroid 3.png"), preload("res://assets/images/Asteroid 4.png")]
var collisions = [preload("res://assets/resources/asteroid_collision_1.tres"), preload("res://assets/resources/asteroid_collision_2.tres"), preload("res://assets/resources/asteroid_collision_3.tres"), preload("res://assets/resources/asteroid_collision_4.tres")]

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var chosen_asteroid = random.randi_range(0,3)
	$Sprite2D.texture = textures[chosen_asteroid]
	$Collision.shape = collisions[chosen_asteroid]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
