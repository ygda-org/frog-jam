extends CharacterBody2D

const SPEED = 200

var random = RandomNumberGenerator.new()

func _ready():
	if random.randi_range(0, 1) == 1:
		velocity = Vector2(SPEED ,0)
		scale.x *= -1
	else:
		velocity = Vector2(-SPEED, 0)

func _physics_process(delta):
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	scale.x *= -1
	velocity.x *= -1
