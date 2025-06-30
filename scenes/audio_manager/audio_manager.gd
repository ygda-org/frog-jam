extends Node2D

@export var sound_effect_settings : Array[SFXSettings]

var sound_effect_dict : Dictionary[SFXSettings.SOUND_EFFECT_LABEL, SFXSettings]

var rng = RandomNumberGenerator.new()

var playing_background_music = true
var prev_state = playing_background_music

func _ready() -> void:
	for setting : SFXSettings in sound_effect_settings:
		sound_effect_dict[setting.label] = setting
	
	var audioplayer : AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(audioplayer)
	var sound_effect_setting = sound_effect_dict[SFXSettings.SOUND_EFFECT_LABEL.IntroSingle]
	audioplayer.stream = sound_effect_setting.stream
	audioplayer.volume_db = sound_effect_setting.volume
	audioplayer.finished.connect(audioplayer.queue_free)
	audioplayer.name = str(sound_effect_setting.label)
	audioplayer.play(sound_effect_setting.audio_start_offset)
	await audioplayer.finished
	playing_background_music = false

func _process(delta: float) -> void:
	if prev_state != playing_background_music:
		print(playing_background_music)
	prev_state = playing_background_music
	if playing_background_music:
		return
	var current_scene = get_tree().root.get_child(1)
	if current_scene == null: return
	if current_scene.name == "StartMenu":
		create_audio(SFXSettings.SOUND_EFFECT_LABEL.IntroLoop)
	else:
		create_audio(SFXSettings.SOUND_EFFECT_LABEL.MainGameSong01)
	playing_background_music = true

func _on_audio_finished(source : AudioStreamPlayer):
	if int(source.name) == 0 or int(source.name) == 16:
		playing_background_music = false

func create_audio(type : SFXSettings.SOUND_EFFECT_LABEL):
	var audioplayer : AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(audioplayer)
	var sound_effect_setting = sound_effect_dict[type]
	audioplayer.stream = sound_effect_setting.stream
	audioplayer.volume_db = sound_effect_setting.volume
	audioplayer.pitch_scale = sound_effect_setting.pitch
	audioplayer.finished.connect(audioplayer.queue_free)
	audioplayer.name = str(sound_effect_setting.label)
	audioplayer.finished.connect(_on_audio_finished.bind(audioplayer))
	audioplayer.play(sound_effect_setting.audio_start_offset)
	#GlobalLog.log("Playing: " + str(sound_effect_setting.label))

func create_audio_with_variance(type : SFXSettings.SOUND_EFFECT_LABEL, pitch_range : Vector2):
	var audioplayer : AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(audioplayer)
	var sound_effect_setting = sound_effect_dict[type]
	audioplayer.stream = sound_effect_setting.stream
	audioplayer.volume_db = sound_effect_setting.volume
	audioplayer.pitch_scale = rng.randf_range(pitch_range.x,pitch_range.y)
	audioplayer.finished.connect(audioplayer.queue_free)
	audioplayer.name = str(sound_effect_setting.label)
	audioplayer.finished.connect(_on_audio_finished.bind(audioplayer))
	audioplayer.play(sound_effect_setting.audio_start_offset)

func clear_all_audio():
	for child in get_children():
		child.queue_free()
	playing_background_music = false
