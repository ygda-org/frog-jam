class_name FrogData
extends Resource

enum Powerups {
	Slowfall,
	Dart,
	Rocket,
	Wood
}

@export var texture: Texture2D
@export var powerup: Powerups
