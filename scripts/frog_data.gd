class_name FrogData
extends Resource

enum Powerups {
	Slowfall,
	Dart,
	Rocket,
}

@export var texture: Texture2D
@export var powerup: Powerups
