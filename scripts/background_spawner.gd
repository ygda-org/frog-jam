extends Node2D

var cloud = preload("res://scenes/clod.tscn")
var star = preload("res://scenes/star.tscn")

var random = RandomNumberGenerator.new()

func spawn_clod(y_pos: int):
	var chosen_cloud = cloud.instantiate()
	var randx = DisplayServer.screen_get_size().x
	chosen_cloud.position.x = randf()*randx-(randx/2)
	#print(chosen_cloud.position.x)
	chosen_cloud.position.y = y_pos - 300
	chosen_cloud.scale = Vector2(1,1) * randf_range(1,3)
	get_parent().add_child(chosen_cloud)

func spawn_star(y_pos: int):
	var chosen_star = star.instantiate()
	var randx = DisplayServer.screen_get_size().x
	chosen_star.position.x = randf()*randx#-(randx/2)
	chosen_star.position.y = y_pos - 300
	get_parent().add_child(chosen_star)
