extends Node
## hardcode ftw

var dash := Ability.new("Dash")
var jump := Ability.new("Jump")
var bomb := Ability.new("Bomb")
var climb := Ability.new("Climb")

var abilities: Array[Ability] = [dash, jump, bomb, climb]

func reset(level: Level) -> void:
	for a in abilities:
		a.bought = false
	dash.cost = level.dash_cost
	jump.cost = level.jump_cost
	bomb.cost = level.bomb_cost
	climb.cost = level.climb_cost
