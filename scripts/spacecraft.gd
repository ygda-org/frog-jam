extends CharacterBody2D

const SPEED = 200

var random = RandomNumberGenerator.new()

var starting_side
var rotationdeg

var behavior # does it act like sputnik or shuttle, 0 for sputnik 1 for shuttle
# Called when the node enters the scene tree for the first time.
func _ready():
	behavior = random.randi_range(0, 1)
	if behavior == 0:
		$Sprite2D.texture = load("res://assets/images/Spacecraft 1.PNG")
		scale = Vector2(0.2, 0.2)
		$Collision2.disabled = false
	elif behavior == 1:
		$Sprite2D.texture = load("res://assets/images/Spacecraft 2.PNG")
		scale = Vector2(0.5, 0.5)
		$Collision1.disabled = false
		
	starting_side = get_viewport().size.x if random.randi_range(0,1) == 0 else 0
	position.x = starting_side
	rotationdeg = random.randi_range(60, 120)
	rotation = (rotationdeg * PI) / 180
	if starting_side != 0:
		rotation += PI
	velocity = Vector2(0, -SPEED).rotated(rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide()
	for i in range(get_slide_collision_count()):
		if get_slide_collision(i).get_collider().name == "Player":
			get_slide_collision(i).get_collider().hit(10)
			
			velocity = velocity.length() * Vector2.RIGHT.rotated(get_slide_collision(i).get_angle())
			get_slide_collision(i).get_collider().velocity = get_slide_collision(i).get_collider().velocity.length() * Vector2.LEFT.rotated(get_slide_collision(i).get_angle()) * 0.5
