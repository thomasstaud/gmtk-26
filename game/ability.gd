class_name Ability
extends Resource

var name: String
var description :String = ""
var cost: int
var bought: bool = false

func _init(_name: String, _description:String):
	name = _name
	description = _description
