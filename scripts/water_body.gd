extends Node2D
class_name WaterBody

const WATER_SPRING = preload("res://scenes/water/water_spring.tscn")

const SPRING_STIFFNESS : float = 0.015
const DAMPENING : float = 0.03
@export var SPRING_GAP_DIST : float = 10
var VIEWPORT_SIZE

@export var starting_y : float = 300

var springs : Array[WaterSpring]

@onready var start_time = Time.get_unix_time_from_system()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	VIEWPORT_SIZE = get_viewport().size * 1/0.385
	position.x -= VIEWPORT_SIZE.x/2
	
	var window_width = VIEWPORT_SIZE.x
	for x in range (-3000, 7100 + SPRING_GAP_DIST, SPRING_GAP_DIST):
		var instance = WATER_SPRING.instantiate()
		instance.target_height = starting_y
		instance.position.y = starting_y
		instance.position.x = x
		add_child(instance)
		springs.append(instance)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_all_water(3)
	draw_water_polygon()

func apply_force(index : int, force : float):
	springs[index].velocity += force

func update_all_water(passes : int):
	for i in range(0, len(springs)):
		for j in range(passes):
			if i > 0:
				springs[i].velocity += (springs[i].velocity - springs[i - 1].velocity) * 0.002
			if i < len(springs) - 1:
				springs[i].velocity += (springs[i].velocity - springs[i + 1].velocity) * 0.002
		springs[i].water_update(SPRING_STIFFNESS, DAMPENING)
		springs[i].sine_sprite_offset((Time.get_unix_time_from_system() - start_time) * 2)

func draw_water_polygon():
	var points : PackedVector2Array
	points.append(Vector2(-3000,3000))
	for spring in springs:
		points.append(Vector2(spring.position.x, spring.wave_position))
	points.append(Vector2(7100, 3000))
	$Polygon2D.polygon = points
