extends Node2D

var current_panel = 0

const SLIDE_SPEED = 1300

var delta_global

var ground_ready = false

@onready var panels = [$Panel1, $Panel2, $Panel3, $Panel4, $Panel5, $Panel6, $Panel7, $Panel8, $Panel9, $Panel10, $Panel11]
var velocities = [Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2()]


func _on_timer_timeout():
	print(current_panel)
	if current_panel == 11:
		$Timer.queue_free()
		return
	enable(panels[current_panel])
	current_panel += 1
	if current_panel == 9:
		$Ground_fade_delay.start()

func enable(panel: Sprite2D):
	panel.visible = true
	velocities[current_panel] = panel.position.direction_to(Vector2(0, 0))
	if current_panel == 5 or current_panel == 10:
		velocities[current_panel] = velocities[current_panel] * 4

func _process(delta):
	delta_global = delta
	for i in range(11):
		if (i == 3 or i == 4 or i == 6 or i == 7) and i <= current_panel and current_panel <= 8:
			fade_in(i, delta)
		if ground_ready:
			fade_in(9, delta)
		panels[i].position += velocities[i] * SLIDE_SPEED * delta
		if panels[i].position.x > -10 and panels[i].position.x < 10 and panels[i].position.y > -10 and panels[i].position.y < 10:
			velocities[i] = Vector2(0,0)
	if (current_panel == 8):
		fade_out_up_to(8, delta)

func fade_in(index: int, delta):
	panels[index].set_modulate(lerp(panels[index].get_modulate(), Color(1,1,1,1), delta*1.2))

func fade_out_up_to(index: int, delta):
	for i in range(index):
		fade_out(i, delta)

func fade_out(index: int, delta):
	panels[index].set_modulate(lerp(panels[index].get_modulate(), Color(1,1,1,-1), delta*5))
	if panels[index].get_modulate() == Color(1,1,1,1):
		panels[index].visible = false


func _on_ground_fade_delay_timeout():
	ground_ready = true
