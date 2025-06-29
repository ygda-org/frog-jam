extends Control

var INTRO = preload("res://scenes/intro_cutscene.tscn")
var ENDING = preload("res://scenes/end_cutscene.tscn")

func _on_button_pressed():
	$Node2D.queue_free()
	$Camera2D.queue_free()
	add_child(INTRO.instantiate())

func win():
	add_child(ENDING.instantiate())
