extends Parallax2D

@onready var blue_rect := $BlueRect
@onready var black_rect := $BlackRect
var camera : Camera2D

const TRANSITION_POINT : int = 200
const TRANSITION_AREA_HEIGHT : int = 100

var rng := RandomNumberGenerator.new()
var cloud = preload("res://scenes/clod.tscn")

var particles_emmiting = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_parent().find_child("Camera2D")
	for i in range(10):
		var rand_altitude = rng.randf_range(-TRANSITION_POINT * 10, 0)
		var rand_x_poz = rng.randf_range(0,5000)
		var instance = cloud.instantiate()
		instance.position = Vector2(rand_x_poz,rand_altitude)
		blue_rect.add_child(instance)
	for child in black_rect.get_children():
		child.emitting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_altitude = (-camera.global_position.y - 30) * 0.01
	black_rect.color.a = max(0, player_altitude - TRANSITION_POINT) / TRANSITION_AREA_HEIGHT
	if(player_altitude - TRANSITION_POINT - TRANSITION_AREA_HEIGHT > 0) && not particles_emmiting:
		for child in black_rect.get_children():
			child.emitting = true
		particles_emmiting = true
	if(player_altitude - TRANSITION_POINT - TRANSITION_AREA_HEIGHT < 0) && particles_emmiting:
		for child in black_rect.get_children():
			child.emitting = false
		particles_emmiting = false
	pass
