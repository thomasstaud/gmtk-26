extends Node

signal time_updated
signal win
signal game_over

const BASE_MS = 1000 * 5
const LEVELS = 2
const LEVEL_PATH = "res://levels/level_%d.tscn"

var current_level: int
var ms: int = BASE_MS

var paused: bool:
	set(value):
		paused = value
		Engine.time_scale = 0 if paused else 1
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CAPTURED
var player: Player


func _ready() -> void:
	paused = true

func _process(delta: float) -> void:
	var delta_ms = int(delta * 1000)
	ms -= delta_ms
	
	if ms <= 0:
		ms = 0
		on_lose()
	
	time_updated.emit(ms)


func change_time(delta: int) -> void:
	ms += delta
	time_updated.emit(ms)

func load_level(level: int):
	if level >= LEVELS:
		push_error("Level %d does not exist!!!" % level)
		return
	current_level = level
	get_tree().change_scene_to_file(LEVEL_PATH % current_level)
	ms = BASE_MS
	AbilityManager.reset()

func start_level():
	player.can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	paused = false

func on_win():
	paused = true
	win.emit()

func on_lose():
	paused = true
	game_over.emit()

func restart():
	load_level(current_level)
