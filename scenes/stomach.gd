extends Node2D

var SIDES = 36
var FROGS = []

func _ready() -> void:
	for child in get_children():
		if child.is_class("RigidBody2D"):
			FROGS.append(child)
	
	var angle_inc = 360/SIDES
	for r in range(1,SIDES):
		var new_c = $static/c1.duplicate()
		new_c.rotation = angle_inc*r
		$static.add_child(new_c)

func impulse(impulse):
	for frog in FROGS:
		frog.apply_impulse(impulse)
