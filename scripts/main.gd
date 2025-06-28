extends Node2D


@export var spawn_margin: int = 200
@export var spawn_interval: int = 500
@export var creatures_per_layer: int = 2
@export var enemies_per_layer: int = 1
@export var bubbles_per_layer: int = 1
@export var spawn_height_margin: int = spawn_interval / 2

@onready var camera: Camera2D = $Camera2D

var FROG_BUBBLE_SCENE: PackedScene = preload("res://scenes/frog_bubble.tscn")

var highest_spawn: float = 0.0

var frog_datas: Array[FrogData] = []

func _ready() -> void:
	# grabbing all of the bubble frog resources
	var dir = DirAccess.open("res://assets/resources")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			frog_datas.append(load("res://assets/resources/" + file_name) as FrogData)
			file_name = dir.get_next()
	else:
		print("Error loading frog datas")
	
	highest_spawn = camera.global_position.y - spawn_margin
	spawn_up_to(camera.global_position.y - spawn_margin)

func _process(delta: float) -> void:
	var cam_top = camera.global_position.y - get_viewport_rect().size.y * 0.5
	if cam_top - spawn_margin < highest_spawn:
		spawn_up_to(cam_top - spawn_margin)
	
	# despawn anything that goes off screen
	for i in get_tree().get_nodes_in_group("despawnable"):
		if i.global_position.y > camera.global_position.y + get_viewport_rect().size.y * 0.5:
			i.queue_free()

func spawn_up_to(target: float) -> void:
	#spawn layers between spawn_interval from highest_spawn down to target
	while highest_spawn > target:
		highest_spawn -= spawn_interval
		spawn_layer_at(highest_spawn)

func spawn_layer_at(y_pos: float) -> void:
	var screen_width: float = get_viewport_rect().size.x
	
	# spawn creatures
	for i in creatures_per_layer:
		var x = randi_range(-screen_width, screen_width)
		var current_creature = load("res://scenes/test_creature.tscn").instantiate() # currently thinking array of path names to do random creatures
		current_creature.position = Vector2(x, y_pos + randi_range(-spawn_height_margin, spawn_height_margin))
		add_child(current_creature)
		# spawn creature at Vector2(x, y_pos + randi_range(-spawn_height-margin, spawn_height_margin))
	
	#spawn enemies
	for i in enemies_per_layer:
		var x = randi_range(-screen_width, screen_width)
		#spawn enemies at Vector2(x, y_pos + randi_range(-spawn_height-margin, spawn_height_margin))
	
	#spawn bubbles
	for i in bubbles_per_layer:
		var x = randi_range(-screen_width, screen_width)
		#spawn bubbles at Vector2(x, y_pos + randi_range(-spawn_height-margin, spawn_height_margin))
		var new_bubble: FrogBubble = FROG_BUBBLE_SCENE.instantiate()
		new_bubble.global_position = Vector2(x, y_pos + randi_range(-spawn_height_margin, spawn_height_margin))
		new_bubble.set_data(frog_datas.pick_random())
		add_child(new_bubble)
