class_name Level
extends Resource

@export var name: String
@export var base_seconds := 50
@export var dash_cost := 1
@export var jump_cost := 1
@export var glide_cost := 1
@export var bomb_cost := 2
@export var climb_cost := 1

var unlocked := false
var best_time := 0
