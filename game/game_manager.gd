extends Node

signal time_updated
signal win
signal game_over

const LEVELS = 5
const LEVEL_SCENE_PATH = "res://levels/level_%d.tscn"
const LEVEL_RES_PATH = "res://levels/level_%d.tres"

var current_level := 0
var time_left_ms: int

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
	
	levels[0].unlocked = true
	AbilityManager.reset(levels[0])
	time_left_ms = levels[0].base_seconds * 1000
	time_updated.emit(time_left_ms)
	
	# DEBUG:
	for level in levels: level.unlocked = true


func _process(delta: float) -> void:
	if paused: return
	
	var delta_ms = int(delta * 1000)
	time_left_ms -= delta_ms
	
	if time_left_ms <= 0:
		time_left_ms = 0
		on_lose()
	
	time_updated.emit(time_left_ms)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		paused = true
		restart()


func change_time(delta: int) -> void:
	time_left_ms += delta
	time_updated.emit(time_left_ms)


func load_level(level: int) -> void:
	if level > LEVELS:
		push_error("Level %d does not exist!!!" % level)
		return
	
	current_level = level
	
	var total_bonus_ms = 0
	for i in range(current_level):
		total_bonus_ms += levels[i].best_time
	
	AbilityManager.reset(levels[level-1])
	get_tree().change_scene_to_file(LEVEL_SCENE_PATH % (current_level + 1))
	
	time_left_ms = (levels[level-1].base_seconds * 1000) + total_bonus_ms
	time_updated.emit(time_left_ms)


func load_next_level() -> void:
	load_level(current_level + 1)


func calculate_remaining_time() -> int:
	var all_level_remaining_time = 0
	for i in range(current_level):
		all_level_remaining_time += (levels[i].base_seconds * 1000) - levels[i].best_time
	return all_level_remaining_time


func start_level() -> void:
	if player:
		player.can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	paused = false


func on_win() -> void:
	paused = true
	win.emit()
	
	if current_level != LEVELS - 1:
		levels[current_level + 1].unlocked = true
	
	if time_left_ms > levels[current_level].best_time:
		levels[current_level].best_time = time_left_ms


func on_lose() -> void:
	paused = true
	game_over.emit()


func restart() -> void:
	load_level(current_level)


func to_level_select() -> void:
	get_tree().change_scene_to_file("uid://cdpcfqx7ugyyd")
