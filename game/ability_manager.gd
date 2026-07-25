extends Node
## hardcode ftw

var dash := Ability.new("Dash", "Yeets the user forward with zero regard for personal safety or structural integrity.")
var jump := Ability.new("Jump", "Temporarily overcomes the tragic reality of skipping leg day for the last 50 years in this academy.")
var bomb := Ability.new("Bomb", "Blows up stuff. Like BOOM!")
var climb := Ability.new("Climb", "Aggressively hugs the architecture to slowly ascend.")
var glide := Ability.new("Glide", "A highly dignified way to delay your inevitable, catastrophic impact with the ground.")

var abilities: Array[Ability] = [dash, jump, glide, bomb, climb]

func reset(level: Level) -> void:
	for a in abilities:
		a.bought = false
	dash.cost = level.dash_cost
	jump.cost = level.jump_cost
	bomb.cost = level.bomb_cost
	climb.cost = level.climb_cost
	glide.cost = level.glide_cost
