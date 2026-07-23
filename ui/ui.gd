extends Control

const ABILITY_TILE := preload("uid://pnriti1de4cj")

@onready var start_panel: MarginContainer = $StartPanel
@onready var game_over: MarginContainer = $GameOver
@onready var win: MarginContainer = $Win
@onready var tile_grid: GridContainer = %TileGrid
@onready var timer: Label = $Timer


func _ready() -> void:
	GameManager.time_updated.connect(on_timer_update)
	GameManager.win.connect(on_win)
	GameManager.game_over.connect(on_game_over)
	generate_ability_tiles()


func format_ms(ms: int) -> String:
	@warning_ignore("integer_division")
	var mins := ms / (1000 * 60)
	@warning_ignore("integer_division")
	var secs := (ms - (1000 * 60 * mins)) / 1000
	var millis := ms % 1000
	
	return "%02d:%02d.%03d" % [mins, secs, millis]


func generate_ability_tiles():
	for ability in AbilityManager.abilities:
		var tile = ABILITY_TILE.instantiate()
		tile_grid.add_child(tile)
		tile.init(ability)


func _on_start_pressed() -> void:
	start_panel.hide()
	GameManager.start_level()

func _on_restart_pressed() -> void:
	GameManager.restart()


func on_timer_update(ms: int) -> void:
	timer.text = format_ms(ms)

func on_win() -> void:
	win.show()

func on_game_over() -> void:
	game_over.show()

func _on_menu_pressed() -> void:
	GameManager.to_level_select()
