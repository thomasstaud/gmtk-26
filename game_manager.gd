extends Node

var paused: bool:
	set(value):
		Engine.time_scale = 0 if value else 1
		paused = value
var player: Player

func _ready() -> void:
	paused = true

func start_level():
	player.can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	paused = false
