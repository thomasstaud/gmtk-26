extends Node

signal time_updated
signal win
signal game_over

const LEVELS = 2
const LEVEL_SCENE_PATH = "res://levels/level_%d.tscn"
const LEVEL_RES_PATH = "res://levels/level_%d.tres"

var current_level := 1
var ms: int

var levels: Array[Level] = []

var paused: bool:
	set(value):
		paused = value
		Engine.time_scale = 0 if paused else 1
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CAPTURED
var player: Player


func _ready() -> void:
	paused = true
	for i in range(LEVELS):
		levels.append(load(LEVEL_RES_PATH % (i + 1)))
	AbilityManager.reset(levels[0])
	ms = levels[0].base_seconds * 1000

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
	if level > LEVELS:
		push_error("Level %d does not exist!!!" % level)
		return
	current_level = level
	AbilityManager.reset(levels[level-1])
	get_tree().change_scene_to_file(LEVEL_SCENE_PATH % current_level)
	ms = levels[level-1].base_seconds * 1000

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

func to_level_select():
	get_tree().change_scene_to_file("uid://cdpcfqx7ugyyd")
