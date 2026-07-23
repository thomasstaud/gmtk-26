class_name LevelSelect
extends Control

const LEVEL_TILE = preload("uid://bel07fy3ndpv0")

@onready var tile_grid: GridContainer = %TileGrid


func _ready() -> void:
	for i in range(GameManager.LEVELS):
		var tile = LEVEL_TILE.instantiate()
		tile_grid.add_child(tile)
		tile.init(i+1)
