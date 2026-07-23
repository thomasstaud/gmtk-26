extends Control

@onready var label: Label = %Label
@onready var button: Button = %Button

var level: int


func init(_level: int):
	level = _level
	
	label.text = "Level %d" % level


func _on_button_pressed() -> void:
	GameManager.load_level(level)
