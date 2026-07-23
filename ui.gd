extends Control

var ms: int = 1000 * 7

@onready var start_panel: MarginContainer = $StartPanel
@onready var game_over: MarginContainer = $GameOver
@onready var timer: Label = $Timer

func _process(delta: float) -> void:
	var delta_ms = int(delta * 1000)
	ms -= delta_ms
	
	if ms <= 0:
		ms = 0
		GameManager.paused = true
		game_over.show()
	
	timer.text = format_ms()


func format_ms() -> String:
	@warning_ignore("integer_division")
	var mins := ms / (1000 * 60)
	@warning_ignore("integer_division")
	var secs := (ms - (1000 * 60 * mins)) / 1000
	var millis := ms % 1000
	
	return "%02d:%02d.%03d" % [mins, secs, millis]


func _on_start_pressed() -> void:
	start_panel.hide()
	GameManager.start_level()


func _on_restart_pressed() -> void:
	GameManager.restart()
