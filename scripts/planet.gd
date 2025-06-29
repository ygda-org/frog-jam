extends StaticBody2D

func _ready() -> void:
	if randi_range(0, 1) == 1:
		$Sprite2D.flip_h = true
