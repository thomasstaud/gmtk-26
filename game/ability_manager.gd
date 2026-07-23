extends Node

var dash := Ability.new("Dash", 1)
var jump := Ability.new("Jump", 1)

var abilities: Array[Ability] = [dash, jump]

func reset():
	for a in abilities:
		a.bought = false
