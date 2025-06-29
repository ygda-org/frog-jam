extends Parallax2D

@onready var blue_rect := $BlueRect
@onready var black_rect := $BlackRect
var camera : Camera2D

const TRANSITION_POINT : int = 200
const TRANSITION_AREA_HEIGHT : int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_parent().find_child("Camera2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_altitude = (-camera.global_position.y - 30) * 0.01
	print(player_altitude)
	black_rect.color.a = max(0, player_altitude - TRANSITION_POINT) / TRANSITION_AREA_HEIGHT
