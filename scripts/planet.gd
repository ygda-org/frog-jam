extends StaticBody2D

func _ready() -> void:
	if randi_range(0, 1) == 1:
		$Sprite2D.flip_h = true

func play_hit_noise():
	#AudioManager.create_audio_with_variance(SFXSettings.SOUND_EFFECT_LABEL.BirdHurt01, Vector2(0.8,1.2))
	pass
