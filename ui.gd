extends Control

var ms: int = 1000 * 60

@onready var margin_container: MarginContainer = $MarginContainer
@onready var timer: Label = $Timer

func _process(delta: float) -> void:
	var delta_ms = int(delta * 1000)
	ms -= delta_ms
	timer.text = format_ms()


func format_ms() -> String:
	@warning_ignore("integer_division")
	var mins := ms / (1000 * 60)
	@warning_ignore("integer_division")
	var secs := (ms - (1000 * 60 * mins)) / 1000
	var millis := ms % 1000
	
	return "%02d:%02d.%03d" % [mins, secs, millis]


func _on_start_pressed() -> void:
	margin_container.hide()
	GameManager.start_level()
