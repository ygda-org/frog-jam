extends Control

var INTRO = preload("res://scenes/intro_cutscene.tscn")
var ENDING = preload("res://scenes/end_cutscene.tscn")

func _on_button_pressed():
	$Node2D.visible = false
	$Camera2D.enabled = false
	add_child(INTRO.instantiate())

func win():
	$Node2D.visible = false
	$Camera2D.enabled = false
	add_child(ENDING.instantiate())

func show_win_text():
	$Label.visible = true
	$ColorRect.visible = true
	$backtotitle.visible = true


func _on_backtotitle_pressed():
	$Label.visible = false
	$ColorRect.visible = false
	$backtotitle.visible = false
	$Node2D.visible = true
	$Camera2D.enabled = true
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
