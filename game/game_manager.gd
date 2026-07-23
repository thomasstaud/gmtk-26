extends Node

var levels: Array[String] = [
	"res://game.tscn",
]

var paused: bool:
	set(value):
		paused = value
		Engine.time_scale = 0 if paused else 1
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CAPTURED
var player: Player

func _ready() -> void:
	paused = true

func start_level():
	player.can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	paused = false

func restart():
	get_tree().change_scene_to_file(levels[0])
