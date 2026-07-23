extends Node
## hardcode ftw

var dash := Ability.new("Dash")
var jump := Ability.new("Jump")
var bomb := Ability.new("Bomb")

var abilities: Array[Ability] = [dash, jump, bomb]

func reset(level: Level) -> void:
	for a in abilities:
		a.bought = false
	dash.cost = level.dash_cost
	jump.cost = level.jump_cost
	bomb.cost = level.bomb_cost
