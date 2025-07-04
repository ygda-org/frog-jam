extends Resource

class_name SFXSettings

enum SOUND_EFFECT_LABEL{
	MainGameSong01,
	BirdChrip01,
	BirdHurt01,
	BirdHurt02,
	FlyBuzz01,
	SnakeHiss01,
	ToadAnnoyed01,
	ToadAnnoyed02,
	ToadQuack01,
	ToadQuack02,
	ToadQuack03,
	ToadQuack04,
	FrogCroak,
	FrogGulp,
	TongueHit,
	TongueStretch,
	IntroLoop,
	IntroSingle,
}

@export var label : SOUND_EFFECT_LABEL
@export var stream : AudioStream
@export_range(-40,24) var volume : float = 1.0
@export_range(0.01, 4.0) var pitch : float = 1.0
@export var audio_start_offset : float = 0.0
