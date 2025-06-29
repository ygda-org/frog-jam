extends StaticBody2D

var random = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	print(random.randi_range(0, 1))
	if random.randi_range(0, 1) == 1:
		$Anim.flip_h = true
