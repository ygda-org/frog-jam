extends Node2D



func _on_animated_sprite_2d_animation_finished():
	get_parent().show_win_text()
	call_deferred("queue_free")
