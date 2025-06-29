class_name HUD
extends Control

@onready var health_label: Label = $"MarginContainer/HBoxContainer/Health Label"
@onready var height_label: Label = $"MarginContainer2/VBoxContainer/Height Label"
@onready var speed_label: Label = $"MarginContainer2/VBoxContainer/Speed Label"

@onready var slowfall: ProgressBar = $MarginContainer3/HBoxContainer/VBoxContainer1/ColorRect
@onready var dart: ProgressBar = $MarginContainer3/HBoxContainer/VBoxContainer2/ColorRect
@onready var rocket: ProgressBar = $MarginContainer3/HBoxContainer/VBoxContainer3/ColorRect
