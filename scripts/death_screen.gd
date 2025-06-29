class_name DeathScreen
extends PanelContainer

signal restart_game

func _ready() -> void:
	self.hide()

func _on_button_pressed() -> void:
	restart_game.emit()
