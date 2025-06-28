class_name Player
extends CharacterBody2D

var JUMP_FORCE: int = 1550
const MAX_GRAVITY: int = 60
var GRAVITY: int = 60
var MAX_SPEED: int = 2000
var FRICTION_AIR: float = 0.95
var CHAIN_PULL: int = 105

@export var powerup_time_length: int = 10

@onready var tongue: Tongue = $Tongue
@onready var powerup_timer: Timer = $Timer
@export var STOMACH: Stomach = null

var chain_velocity := Vector2(0,0)

var poisonous : bool = false

func _ready() -> void:
	self.powerup_timer.wait_time = self.powerup_time_length

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			#tongue.shoot(self.get_local_mouse_position() - to_local(tongue.position))
			tongue.shoot(tongue.get_local_mouse_position())
			
			#print(to_local(tongue.position))
		else:
			tongue.release()


func _physics_process(_delta: float) -> void:
	velocity.y += GRAVITY

	if tongue.hooked:
		chain_velocity = tongue.to_local(tongue.tip_position).normalized() * CHAIN_PULL
	else:
		chain_velocity = Vector2(0,0)
		
	velocity += chain_velocity

	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	
	var collision = move_and_collide(velocity * _delta)
	if collision:
		if collision.get_collider() == tongue.hooked_creature:
			tongue.release()
		collision.get_collider().queue_free()
	
	STOMACH.impulse(-velocity*0.2)

	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	# air friction
	
	velocity.x *= FRICTION_AIR
	if velocity.y > 0:
		velocity.y *= FRICTION_AIR
		
	position.y = min(0.0, position.y)

func enemy_collision(enemy: Variant):
	if poisonous:
		enemy.suicide()
	else:
		print("Player collided with: " + str(enemy))

func collect_frog(frog_data: FrogData) -> void:
	STOMACH.add_creature(frog_data.texture)
	
	match frog_data.powerup:
		FrogData.Powerups.Slowfall:
			print("Slow fall attained!")
			self.GRAVITY = self.MAX_GRAVITY / 2
			self.powerup_timer.timeout.connect(func():
				self.GRAVITY = self.MAX_GRAVITY
				#print("slowfall deactivated")
				)
			self.powerup_timer.one_shot = true
			self.powerup_timer.start()
			#print("slowfall activated")
		FrogData.Powerups.Dart:
			print("Poison attained!")
			poisonous = true
			self.powerup_timer.timeout.connect(func():
				poisonous = false
				)
			self.powerup_timer.one_shot = true
			self.powerup_timer.start()
