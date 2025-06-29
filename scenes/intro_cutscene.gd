extends Node2D

var current_panel = 0 # do 0, 8, 11, 12, 19, 21 for different scenes

const SLIDE_SPEED = 1300

var delta_global

var ground_ready = false

var panel_12_fading_in = false
var panel_12_fading_out = false

var fade_out_scene_4 = false

var flashing = false

@onready var panels = [$Panel1, $Panel2, $Panel3, $Panel4, $Panel5, $Panel6, $Panel7, $Panel8, $Panel9, $Panel10, $Panel11, $Panel12, $Panel13, $Panel15, $Panel14, $Panel16, $Panel17, $Panel18, $Panel19, $Panel20, $Panel21, $Panel23, $Panel22]
var velocities = [Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2()]

func _on_timer_timeout():
	print(current_panel)
	if current_panel == 22:
		$Timer.queue_free()
		return
	if current_panel != 11:
		enable(panels[current_panel])
	else:
		panel_12_fading_in = true
		$Panel12.play("default")
		return
	current_panel += 1
	if current_panel == 4:
		current_panel += 1
		_on_timer_timeout()
		#maybe needs a return?
	if current_panel == 12:
		current_panel += 1
		_on_timer_timeout()
		return
	if current_panel == 15 or current_panel == 16:
		current_panel += 1
		_on_timer_timeout()
		return
	if current_panel == 18 or current_panel == 19:
		fade_out_scene_4 = true
		current_panel += 1
		$PreFlashDelay.start()
		_on_timer_timeout()
		return

	if current_panel == 9:
		$Ground_fade_delay.start()
	if current_panel == 10:
		$umbrella_delay.start()
		$scene_2_end_delay.start()
		return
	$Timer.start()

func enable(panel: Sprite2D):
	panel.visible = true
	velocities[current_panel] = panel.position.direction_to(Vector2(0, 0))
	if current_panel == 5 or current_panel == 10:
		velocities[current_panel] = velocities[current_panel] * 4

func _process(delta):
	if current_panel >= 13:
		$Panel14.rotation = $Panel14.rotation + PI/3600
		$Panel14.scale = $Panel14.scale * 0.999
	if current_panel >= 20:
		$Panel20.rotation = $Panel20.rotation + PI/900
	if flashing:
		$Flash.color = (lerp($Flash.color, Color(1,1,1,1), delta))
	if panel_12_fading_in:
		fade_in(11, delta)
	if panel_12_fading_out:
		fade_out(11, delta)
	delta_global = delta
	for i in range(23):
		if (i == 3 or i == 4 or i == 6 or i == 7) and i <= current_panel and current_panel <= 8:
			fade_in(i, delta)
		if ground_ready and current_panel <= 11:
			fade_in(9, delta)
		if (i >= 12 and i <= 17) and i <= current_panel and current_panel <= 18:
			fade_in(i, delta)
		if (i >= 18 and i <= 20) and i <= current_panel and current_panel <= 21:
			fade_in(i, delta)
		if (i >= 21 and i <= 22) and i <= current_panel and current_panel <= 23:
			fade_in(i, delta)
		var old_panel_position = panels[i].position
		panels[i].position += velocities[i] * SLIDE_SPEED * delta
		if (old_panel_position.x * panels[i].position.x < 0) or (old_panel_position.y * panels[i].position.y < 0):
			panels[i].position = Vector2(0,0)
			velocities[i] = Vector2(0,0)
	if (current_panel == 8):
		fade_out_up_to(8, delta)
	if current_panel == 11:
		fade_out_up_to(11, delta)
	if fade_out_scene_4:
		fade_out_up_to(17, delta)
	if current_panel == 21:
		fade_out_up_to(21, delta)
		$Flash.color = lerp($Flash.color, Color(1,1,1,-1), delta*2)

func fade_in(index: int, delta):
	panels[index].set_modulate(lerp(panels[index].get_modulate(), Color(1,1,1,1), delta*1.2))

func fade_out_up_to(index: int, delta):
	for i in range(index):
		fade_out(i, delta)

func fade_out(index: int, delta):
	panels[index].set_modulate(lerp(panels[index].get_modulate(), Color(1,1,1,-1), delta*2))
	if panels[index].get_modulate() == Color(1,1,1,1):
		panels[index].visible = false


func _on_ground_fade_delay_timeout():
	ground_ready = true


func _on_scene_2_end_delay_timeout():
	ground_ready = false
	$Timer.start()


func _on_umbrella_delay_timeout():
	enable(panels[current_panel])


func _on_panel_12_animation_finished():
	panel_12_fading_in = false
	panel_12_fading_out = true
	current_panel += 1
	$Panel12.visible = false
	$Timer.start()


func _on_pre_flash_delay_timeout():
	flashing = true
