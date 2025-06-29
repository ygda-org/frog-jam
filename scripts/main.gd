extends Node2D


@export var spawn_margin: int = 1500
@export var spawn_interval: int = 750
@export var creatures_per_layer: int = 4
@export var enemies_per_layer: int = 1
@export var bubbles_per_layer: int = 1
@export var spawn_height_margin: int = spawn_interval / 2

@onready var camera: Camera2D = $Camera2D

@onready var death_screen: DeathScreen = $"CanvasLayer/Death Screen"

var FROG_BUBBLE_SCENE: PackedScene = preload("res://scenes/frog_bubble.tscn")

var enemy_scenes: Dictionary = {
	"kite": preload("res://scenes/enemies/kite.tscn"),
	"asteroid": preload("res://scenes/enemies/asteroid.tscn"),
	"spacecraft": preload("res://scenes/enemies/spacecraft.tscn")
}

var edible_scenes: Dictionary = {
	"fly": preload("res://scenes/fly.tscn"),
	"bird": preload("res://scenes/bird.tscn"),
	"dragonfly": preload("res://scenes/dragonfly.tscn"),
	#"planet": preload()
}

var highest_spawn: float = 0.0

var frog_datas: Array[FrogData] = []

func _ready() -> void:
	# grabbing all of the bubble frog resources
	var dir = DirAccess.open("res://assets/resources/frog_resources")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			frog_datas.append(load("res://assets/resources/frog_resources/" + file_name) as FrogData)
			file_name = dir.get_next()
	else:
		print("Error loading frog datas")
	
	highest_spawn = camera.global_position.y - spawn_margin / 3
	spawn_up_to(highest_spawn)
	
	get_tree().paused = false

func _process(delta: float) -> void:
	var cam_top = camera.global_position.y - get_viewport_rect().size.y * 0.5
	if cam_top - spawn_margin < highest_spawn:
		spawn_up_to(cam_top - spawn_margin)

func spawn_up_to(target: float) -> void:
	#spawn layers between spawn_interval from highest_spawn down to target
	while highest_spawn > target:
		highest_spawn -= spawn_interval
		spawn_layer_at(highest_spawn)

func spawn_layer_at(y_pos: float) -> void:
	var screen_width: float = get_viewport().get_visible_rect().size.x * 3

	var height_meters: float = (y_pos - 30) * -0.01
	
	var edible_distributions: Dictionary
	var enemy_distributions: Dictionary
	
	if height_meters < 350:
		edible_distributions = {
			"fly": 3,
			"dragonfly": 2,
			"bird": 1
		}
		enemy_distributions = {
			"kite": 1
		}
	elif height_meters < 700:
		edible_distributions = {
			"fly": 1,
			"dragonfly": 1.5,
			"bird": 2
		}
		enemy_distributions = {
			"kite": 5,
			"asteroid": 1
		}
	else:
		edible_distributions = {
			"planet": 1
		}
		enemy_distributions = {
			"asteroid": 2,
			"spacecraft": 1
		}
		
	
	# spawn creatures
	for i in creatures_per_layer:
		var x = randi_range(-screen_width, screen_width)
		#var current_creature = load("res://scenes/bird.tscn").instantiate() # currently thinking array of path names to do random creatures
		var current_creature = edible_scenes[weighted_random(edible_distributions)].instantiate()
		current_creature.position = Vector2(x, y_pos + randi_range(-spawn_height_margin, spawn_height_margin))
		add_child(current_creature)
		# spawn creature at Vector2(x, y_pos + randi_range(-spawn_height-margin, spawn_height_margin))
	
	#spawn enemies
	for i in enemies_per_layer:
		var x = randi_range(-screen_width, screen_width)
		#var current_enemy = load("res://scenes/enemies/asteroid.tscn").instantiate()
		var current_enemy = enemy_scenes[weighted_random(enemy_distributions)].instantiate()
		current_enemy.position = Vector2(x, y_pos + randi_range(-spawn_height_margin, spawn_height_margin))
		add_child(current_enemy)
		#spawn enemies at Vector2(x, y_pos + randi_range(-spawn_height_margin, spawn_height_margin))
	
	#spawn bubbles
	for i in bubbles_per_layer:
		var x = randi_range(-screen_width, screen_width)
		#spawn bubbles at Vector2(x, y_pos + randi_range(-spawn_height-margin, spawn_height_margin))
		var new_bubble: FrogBubble = FROG_BUBBLE_SCENE.instantiate()
		new_bubble.global_position = Vector2(x, y_pos + randi_range(-spawn_height_margin, spawn_height_margin))
		new_bubble.set_data(frog_datas.pick_random())
		add_child(new_bubble)

func _on_player_player_dead() -> void:
	death_screen.show()
	get_tree().paused = true

func _on_death_screen_restart_game() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func weighted_random(choices: Dictionary):
	# choices is the options with the keys as the weights
	var total_weight: float = 0.0
	for i in choices:
		total_weight += choices[i]
	
	var threshold: float = randf_range(0.0, total_weight)
	var accumulated_weight: float = 0.0
	for choice in choices:
		accumulated_weight += choices[choice]
		if accumulated_weight >= threshold:
			return choice
	return choices.keys()[-1]

func win():
	get_parent().win()
	call_deferred("queue_free")
