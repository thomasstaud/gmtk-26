extends Node
## hardcode ftw

var dash := Ability.new("Woosh", "Slings you forward with zero respect to your safety and structural integrity")
var jump := Ability.new("Frog Leap", "Skipping leg day is fine when you have this bad boy in your spell book.")
var bomb := Ability.new("Bomb", "This is not even a spell. You just brought some explosives.")
var climb := Ability.new("Gecko Hands", "Scale Rocks and Hedges with your amazing, disgusting new hands.")
var glide := Ability.new("Levitate", "At your current skill level, this just makes you fall slower.")

var abilities: Array[Ability] = [dash, jump, glide, bomb, climb]

func reset(level: Level) -> void:
	for a in abilities:
		a.bought = false
	dash.cost = level.dash_cost
	jump.cost = level.jump_cost
	bomb.cost = level.bomb_cost
	climb.cost = level.climb_cost
	glide.cost = level.glide_cost
