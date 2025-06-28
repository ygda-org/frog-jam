class_name Tongue
extends Node2D

@onready var tongue_middle_sprite: Sprite2D = $"Tongue Middle"
@onready var tongue_tip: CharacterBody2D = $"Tongue Tip"

@onready var frog: CharacterBody2D = get_parent()

var direction: Vector2 = Vector2.ZERO
var tip_position: Vector2 = Vector2.ZERO

var flying: bool = false
var hooked: bool = false

var hooked_creature = null

const SPEED: int = 50


func shoot(dir: Vector2) -> void:
	self.direction = dir.normalized()
	self.flying = true
	self.tip_position = self.global_position
	
func release() -> void:
	self.flying = false
	self.hooked = false
	self.hooked_creature = null

func _process(_delta: float) -> void:
	self.visible = self.flying or self.hooked
	if not self.visible:
		return
	
	var tip_loc: Vector2 = self.to_local(self.tip_position)
	
	
	# make the tongue actually point towards target
	self.tongue_middle_sprite.rotation = self.position.angle_to_point(tip_loc) + deg_to_rad(90)
	self.tongue_tip.rotation = self.tongue_middle_sprite.rotation
	
	self.tongue_middle_sprite.position = tip_loc
	self.tongue_middle_sprite.region_rect.size.y = tip_loc.length()
	

func _physics_process(delta: float) -> void:
	self.tongue_tip.global_position = self.tip_position
	
	#if flying and self.tongue_tip.move_and_collide(direction * SPEED):
		#self.hooked = true
		#self.flying = false
	if flying:
		var collision: KinematicCollision2D = self.tongue_tip.move_and_collide(direction * SPEED)
		if collision:
			self.hooked_creature = collision.get_collider()
			self.hooked = true
			self.flying = false
	
	self.tip_position = self.tongue_tip.global_position
