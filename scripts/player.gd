class_name Player
extends CharacterBody2D

signal player_dead

var JUMP_FORCE: int = 1550
const MAX_GRAVITY: int = 60
var GRAVITY: int = 60
var MAX_SPEED: int = 2000
var FRICTION_AIR: float = 0.975
var CHAIN_PULL: int = 105

var health = 100
var invincible = false

@export var powerup_time_length: int = 10

@onready var tongue: Tongue = $Tongue
@onready var slowfall_timer: Timer = $SlowfallTimer
@onready var dart_timer: Timer = $DartTimer
@onready var rocket_timer: Timer = $RocketTimer
@export var STOMACH: Stomach = null
@export var HUD: HUD = null

var chain_velocity := Vector2(0,0)

var poisonous : bool = false

func _ready() -> void:
	self.slowfall_timer.wait_time = self.powerup_time_length
	self.dart_timer.wait_time = self.powerup_time_length
	self.rocket_timer.wait_time = self.powerup_time_length
	
	set_deferred("HUD.rocket.max_value", powerup_time_length)
	set_deferred("HUD.dart.max_value", powerup_time_length)
	set_deferred("HUD.slowfall.max_value", powerup_time_length)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			tongue.shoot(tongue.get_local_mouse_position())
		else:
			tongue.retract()


func _physics_process(_delta: float) -> void:
	velocity.y += GRAVITY

	if tongue.hooked:
		if $Anim.animation != "expanded" and $Anim.animation != "expand":
			$Anim.play("expand")
		chain_velocity = tongue.to_local(tongue.tip_position).normalized() * CHAIN_PULL
	else:
		if $Anim.animation != "collapsed" and $Anim.animation != "collapse":
			$Anim.play("collapse")
		chain_velocity = Vector2(0,0)
		
	velocity += chain_velocity

	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	
	var collision = move_and_collide(velocity * _delta)
	if collision:
		if collision.get_collider() == tongue.hooked_creature:
			tongue.release()
		call_deferred("kill", collision.get_collider())
		scale += Vector2(0.03, 0.03)
		if collision.get_collider().name == "Sun":
			get_parent().win()
	
	STOMACH.impulse(-velocity*0.2)
	
	var unit_scale = 0.01
	HUD.height_label.text = str(-(int((position.y-30)*unit_scale))) + " m"
	HUD.speed_label.text = str(int(sqrt(velocity.x**2+velocity.y**2)*unit_scale)) + " m/s"
	HUD.rocket.value = rocket_timer.time_left
	HUD.dart.value = dart_timer.time_left
	HUD.slowfall.value = slowfall_timer.time_left
	
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
		#return false
	#else:
		#return true

func collect_frog(frog_data: FrogData) -> void:
	STOMACH.add_creature(frog_data.texture)
	
	match frog_data.powerup:
		FrogData.Powerups.Slowfall:
			#print("Slow fall attained!")
			self.GRAVITY = self.MAX_GRAVITY / 2
			self.slowfall_timer.timeout.connect(func():
				self.GRAVITY = self.MAX_GRAVITY
				#print("slowfall deactivated")
				)
			self.slowfall_timer.one_shot = true
			self.slowfall_timer.start()
			#print("slowfall activated")
		FrogData.Powerups.Dart:
			#print("Poison attained!")
			poisonous = true
			self.dart_timer.timeout.connect(func():
				poisonous = false
				)
			self.dart_timer.one_shot = true
			self.dart_timer.start()
		FrogData.Powerups.Rocket:
			tongue.SPEED = 150
			self.rocket_timer.timeout.connect(func():
				tongue.SPEED = 50)
			self.rocket_timer.one_shot = true
			self.rocket_timer.start()
		FrogData.Powerups.Wood:
			health += 20

func hit(dmg: int):
	if not (invincible or poisonous):
		invincible = true
		collision_layer = 0
		health -= dmg
		health = max(health, 0)
		HUD.health_label.text = str(health)
		$IFrames.start()
		
		if health <= 0:
			player_dead.emit()

func kill(to_be_killed: Variant): # calls queue_free on object
	to_be_killed.queue_free()

func _on_i_frames_timeout():
	invincible = false
	collision_layer = 2


func _on_anim_animation_finished():
	if $Anim.animation == "collapse":
		$Anim.play("collapsed")
	elif $Anim.animation == "expand":
		$Anim.play("expanded")
