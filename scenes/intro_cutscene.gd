extends Node2D

var current_panel = 0

const SLIDE_SPEED = 1300

@onready var panels = [$Panel1, $Panel2, $Panel3, $Panel4, $Panel5, $Panel6, $Panel7, $Panel8]
var velocities = [Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), Vector2()]

func _ready():
	panels[4].set_modulate(Color(1, 1, 1, 0))

func _on_timer_timeout():
	print(current_panel)
	if current_panel == 8:
		$Timer.queue_free()
		return
	enable(panels[current_panel])
	current_panel += 1

func enable(panel: Sprite2D):
	panel.visible = true
	velocities[current_panel] = panel.position.direction_to(Vector2(0, 0))
	if current_panel == 5:
		velocities[current_panel] = velocities[current_panel] * 4

func _process(delta):
	for i in range(8):
		if (i == 3 or i == 4 or i == 6 or i == 7) and i <= current_panel:
			fade_in(i, delta)
		panels[i].position += velocities[i] * SLIDE_SPEED * delta
		if panels[i].position.x > -10 and panels[i].position.x < 10 and panels[i].position.y > -10 and panels[i].position.y < 10:
			velocities[i] = Vector2(0,0)

func fade_in(index: int, delta):
	panels[index].set_modulate(lerp(panels[index].get_modulate(), Color(1,1,1,1), delta*1.2))
