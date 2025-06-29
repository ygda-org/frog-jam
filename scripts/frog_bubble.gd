class_name FrogBubble
extends CharacterBody2D

@export var frog_data: FrogData

@export var noise_x: FastNoiseLite = FastNoiseLite.new()
@export var noise_y: FastNoiseLite = FastNoiseLite.new()

@onready var frog_sprite: Sprite2D = $FrogSprite

#var max_velocity: Vector2 = Vector2(100, 100)
var max_velocity: int = 100
var rotation_speed: float

var random = RandomNumberGenerator.new()

var time_offset: int

func _ready():
	random.randomize()
	if random.randi_range(0, 1) == 1:
		scale.x *= -1
	
	noise_x.seed = randi_range(-100000, 100000)
	noise_y.seed = randi_range(-100000, 100000)
	
	rotation_speed = random.randf()
	
	time_offset = randi_range(-100000, 100000)


func _physics_process(delta: float) -> void:
	var t = Time.get_ticks_msec() / 100 + time_offset
	
	self.velocity = Vector2(noise_x.get_noise_1d(t), noise_y.get_noise_1d(t)) * max_velocity
	
	frog_sprite.rotate(rotation_speed * delta)
	
	move_and_slide()

func set_data(new_data: FrogData) -> void:
	self.frog_data = new_data
	$FrogSprite.texture = new_data.texture

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	(body as Player).collect_frog(frog_data)
	self.queue_free()
