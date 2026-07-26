class_name LevelSelect
extends Control

const LEVEL_TILE = preload("uid://bel07fy3ndpv0")

@onready var tile_grid: GridContainer = %TileGrid
@onready var leaderboard: Button = %Leaderboard


func _ready() -> void:
	for i in range(GameManager.LEVELS):
		var tile = LEVEL_TILE.instantiate()
		tile_grid.add_child(tile)
		tile.init(i, GameManager.levels[i])
	#leaderboard.visible = GameManager.is_leaderboard_unlocked()
	leaderboard.visible = true


func _on_leaderboard_pressed() -> void:
	GameManager.to_leaderboard()
