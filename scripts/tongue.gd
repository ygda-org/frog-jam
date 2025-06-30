class_name Tongue
extends Node2D

@onready var tongue_middle_sprite: Sprite2D = $"Tongue Middle"
@onready var tongue_tip: CharacterBody2D = $"Tongue Tip"

@onready var frog: CharacterBody2D = get_parent()

@export var max_tongue_length: int = 7500

var direction: Vector2 = Vector2.ZERO
var tip_position: Vector2 = Vector2.ZERO

var flying: bool = false
var hooked: bool = false
var retracting: bool = false

var hooked_creature = null
var relative_hooked_position: Vector2

var SPEED: int = 50


func shoot(dir: Vector2) -> void:
	if !flying and !retracting:
		self.direction = dir.normalized()
		self.flying = true
		self.tip_position = self.global_position
		self.retracting = false
		self.hooked = false
	
func release() -> void:
	#self.retracting = to_local(self.tip_position).length() > 1000
	self.retracting = false
	self.flying = false
	self.hooked = false
	self.hooked_creature = null

func retract() -> void:
	self.retracting = true
	self.flying = false
	self.hooked = false
	self.hooked_creature = null

func _process(_delta: float) -> void:
	tongue_tip.visible = self.flying or self.hooked or self.retracting
	tongue_middle_sprite.visible = tongue_tip.visible
	
	if tongue_tip.visible:
		var tip_loc: Vector2 = self.to_local(self.tip_position)
		
		# make the tongue actually point towards target
		self.tongue_middle_sprite.rotation = self.position.angle_to_point(tip_loc) + deg_to_rad(90)
		self.tongue_tip.rotation = self.tongue_middle_sprite.rotation
		
		self.tongue_middle_sprite.position = tip_loc
		self.tongue_middle_sprite.region_rect.size.y = tip_loc.length()
	else:
		self.tip_position = self.global_position
	
func _physics_process(delta: float) -> void:
	self.tongue_tip.global_position = self.tip_position
	
	if flying:
		var collision: KinematicCollision2D = self.tongue_tip.move_and_collide(direction * SPEED)
		if collision:
			AudioManager.create_audio_with_variance(SFXSettings.SOUND_EFFECT_LABEL.TongueHit, Vector2(0.8,1))
			self.hooked_creature = collision.get_collider()
			if self.hooked_creature.has_method("play_hit_noise"):
				self.hooked_creature.play_hit_noise()
			if self.hooked_creature.name == "Bird":
				relative_hooked_position = self.hooked_creature.global_position - self.tongue_tip.global_position
			self.hooked = true
			self.flying = false
			self.retracting = false
		if to_local(self.tip_position).length() > max_tongue_length:
			retract()
	elif retracting:
		var collision: KinematicCollision2D = self.tongue_tip.move_and_collide(-to_local(self.tip_position).normalized() * SPEED * 1.5)
		if collision:
			#AudioManager.create_audio_with_variance(SFXSettings.SOUND_EFFECT_LABEL.TongueHit, Vector2(0.8,1))
			self.hooked_creature = collision.get_collider()
			self.hooked = true
			self.flying = false
			self.retracting = false
		
		if to_local(self.tip_position).length() < 500:
			self.hooked = false
			self.flying = false
			self.retracting = false
	elif hooked:
		if self.hooked_creature == null:
			print("ERROR WOULD OCCUR")
			hooked = false
			return
		if self.hooked_creature is CharacterBody2D:
			tongue_tip.global_position.x += self.hooked_creature.velocity.x * delta
	self.tip_position = self.tongue_tip.global_position


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	release()
