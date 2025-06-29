extends Node2D
class_name WaterSpring

@export var target_height : int
var velocity : float = 0
var wave_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_position = position.y

func water_update(k, d):
	var loss = -d * velocity
	var force = -k * (position.y - target_height) + loss
	velocity += force
	position.y += velocity

func sine_sprite_offset(phase : float):
	wave_position = position.y + sin(phase + position.x) * 20
