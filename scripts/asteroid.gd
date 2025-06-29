extends CharacterBody2D

var textures = [preload("res://assets/images/Asteroid 1.png"), preload("res://assets/images/Asteroid 2.png"), preload("res://assets/images/Asteroid 3.png"), preload("res://assets/images/Asteroid 4.png")]
var collisions = [preload("res://assets/resources/asteroid_collision_1.tres"), preload("res://assets/resources/asteroid_collision_2.tres"), preload("res://assets/resources/asteroid_collision_3.tres"), preload("res://assets/resources/asteroid_collision_4.tres")]

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var chosen_asteroid = random.randi_range(0,3)
	$Sprite2D.texture = textures[chosen_asteroid]
	$Collision.shape = collisions[chosen_asteroid]
	velocity = Vector2(random.randi_range(-10, 10), random.randi_range(1, 5)) * 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_and_slide()
	for i in range(get_slide_collision_count()):
		if get_slide_collision(i).get_collider().name == "Player":
			get_slide_collision(i).get_collider().hit(100)
			
			velocity = velocity.length() * Vector2.RIGHT.rotated(get_slide_collision(i).get_angle())
			get_slide_collision(i).get_collider().velocity = get_slide_collision(i).get_collider().velocity.length() * Vector2.LEFT.rotated(get_slide_collision(i).get_angle()) * 0.5
