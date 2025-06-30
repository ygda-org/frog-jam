extends StaticBody2D

var random = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	if random.randi_range(0, 1) == 1:
		$Anim.flip_h = true

func play_hit_noise():
	#AudioManager.create_audio_with_variance(SFXSettings.SOUND_EFFECT_LABEL.BirdHurt01, Vector2(0.8,1.2))
	pass
