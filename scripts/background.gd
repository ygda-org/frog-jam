extends Parallax2D

@onready var blue_rect := $BlueRect
@onready var black_rect := $BlackRect
var camera : Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_parent().find_child("Camera2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	black_rect.color.a = -camera.global_position.y / 10000
