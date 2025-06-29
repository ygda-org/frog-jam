class_name Stomach
extends Node2D

var SIDES: int = 36
var FROGS: Array[StoredFrog] = []

var frog_scale: Vector2 = Vector2.ONE

var stored_creature_scene: PackedScene = preload("res://scenes/stored_frog.tscn")

func _ready() -> void:	
	var angle_inc = 360/SIDES
	for r in range(1,SIDES):
		var new_c = $static/c1.duplicate()
		new_c.rotation = angle_inc * r
		$static.add_child(new_c)

func add_creature(texture: Texture2D) -> void:
	var new_frog: StoredFrog = stored_creature_scene.instantiate()
	#add_child(new_frog)
	add_child.call_deferred(new_frog)
	
	await new_frog.ready
	
	new_frog.sprite.texture = texture
	#new_frog.collision_shape.shape.radius = min(texture.get_height(), texture.get_width())
	FROGS.append(new_frog)
	
	frog_scale *= 0.75
	for frog: StoredFrog in FROGS:
		frog.scale = frog_scale
	
	if len(FROGS) > 5:
		remove_child.call_deferred(FROGS.pop_front())
	
	#print(len(FROGS))

func impulse(impulse) -> void:
	for frog in FROGS:
		frog.apply_impulse(impulse)
