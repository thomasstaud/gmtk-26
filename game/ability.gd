class_name Ability
extends Resource

var name: String
var cost: int
var bought: bool = false

func _init(_name: String):
	name = _name
