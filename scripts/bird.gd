extends CharacterBody2D

var VIEWPORT_WIDTH = 0

const SPEED = 200

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	VIEWPORT_WIDTH = get_viewport().size
	if random.randi_range(0, 1) == 1:
		velocity = Vector2(SPEED ,0)
		scale.x *= -1
	else:
		velocity = Vector2(-SPEED, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if position.x > VIEWPORT_WIDTH.x or position.x < -VIEWPORT_WIDTH.x:
		scale.x *= -1
		velocity.x *= -1
	move_and_slide()
