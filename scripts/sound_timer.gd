extends Node2D

@export var chosen_sound : SFXSettings.SOUND_EFFECT_LABEL
@export var pitch_variance : Vector2
@export var wait_time : Vector2
@export var initial_wait : Vector2

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start(rng.randf_range(initial_wait.x, initial_wait.y))

func _on_timer_timeout() -> void:
	AudioManager.create_audio_with_variance(chosen_sound,pitch_variance)
	$Timer.start(rng.randf_range(wait_time.x, wait_time.y))
