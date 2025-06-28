extends Node2D

var cloud = preload("res://scenes/clod.tscn")

var random = RandomNumberGenerator.new()

func spawn_clod(y_pos: int):
	var chosen_cloud = cloud.instantiate()
	chosen_cloud.position.y = y_pos
	get_parent().add_child(chosen_cloud)
