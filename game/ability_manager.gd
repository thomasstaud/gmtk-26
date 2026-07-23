extends Node

var dash := Ability.new("Dash", 10)
var jump := Ability.new("Jump", 10)

var abilities: Array[Ability] = [dash, jump]

func reset():
	for a in abilities:
		a.bought = false
