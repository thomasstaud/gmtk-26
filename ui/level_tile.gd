extends Control

@onready var panel: Panel = $Panel
@onready var label: Label = %Label
@onready var time: Label = %Time
@onready var button: Button = %Button

var index: int


func init(_index: int, _level: Level):
	index = _index
	
	label.text = _level.name
	if _level.best_time != 0:
		time.text = UI.format_ms(_level.best_time)
	else:
		time.text = "--:--.---"
	
	if not _level.unlocked:
		panel.modulate = Color.DIM_GRAY
		button.disabled = true
		button.text = "locked"


func _on_button_pressed() -> void:
	GameManager.load_level(index)
