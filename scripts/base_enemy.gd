extends Node2D

class_name Base_Enemy

@onready var parent : CharacterBody2D = get_parent()
@export var damage_dealt : int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(parent.get_slide_collision_count()):
		var collision_obj := parent.get_slide_collision(i).get_collider()
		if collision_obj != null  && collision_obj.name == "Player":
			collision_obj.hit(damage_dealt)
			collision_obj.enemy_collision(self)

func suicide():
	parent.call_deferred("queue_free")


func _on_visible_on_screen_notifier_2d_screen_exited():
	suicide()
