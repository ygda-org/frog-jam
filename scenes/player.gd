extends CharacterBody2D

const JUMP_FORCE = 1550
const GRAVITY = 60
const MAX_SPEED = 2000
const FRICTION_AIR = 0.95
const CHAIN_PULL = 105

@export var rest_length: float = 200.0
@export var stiffness: float = 5.0
@export var damping: float = 1.0

@onready var tongue: Tongue = $Tongue

var chain_velocity := Vector2(0,0)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			tongue.shoot(event.position - get_viewport().size * 0.5)
		else:
			tongue.release()

func _physics_process(_delta: float) -> void:
	velocity.y += GRAVITY

	if tongue.hooked:
		chain_velocity = to_local(tongue.tip_position).normalized() * CHAIN_PULL
	else:
		chain_velocity = Vector2(0,0)
		
	velocity += chain_velocity

	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()

	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	var grounded = is_on_floor()
	if grounded:
		if velocity.y >= 5:
			velocity.y = 5
	elif is_on_ceiling() and velocity.y <= -5:
		velocity.y = -5

	# air friction
	if !grounded:
		velocity.x *= FRICTION_AIR
		if velocity.y > 0:
			velocity.y *= FRICTION_AIR
