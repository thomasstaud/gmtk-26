class_name Ability
extends Resource

@export var name: String
@export var cost: int
@export var bought: bool = false

func _init(_name: String, _cost: int):
	name = _name
	cost = _cost
