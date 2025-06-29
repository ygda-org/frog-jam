extends Control


func _on_button_pressed():
	add_child(load("res://scenes/intro_cutscene.tscn").instantiate())
	$Node2D.queue_free()
	$Camera2D.queue_free()
