extends CharacterBody2D
class_name Kite

var origin_position : Vector2
var offset_position : Vector2
var shake_radius = 5
@onready var start_time = Time.get_unix_time_from_system()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	origin_position = position
	offset_position = origin_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var elapsed_time = Time.get_unix_time_from_system() - start_time
	offset_position.x = origin_position.x + cos(elapsed_time) * shake_radius
	offset_position.y = origin_position.y + sin(elapsed_time) * shake_radius
	position = offset_position
