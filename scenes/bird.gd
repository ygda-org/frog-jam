extends CharacterBody2D

var VIEWPORT_WIDTH = 0

const SPEED = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	VIEWPORT_WIDTH = get_viewport().size
	velocity = Vector2(SPEED, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if position.x > VIEWPORT_WIDTH.x or position.x < 0:
		velocity.x *= -1
	move_and_slide()
