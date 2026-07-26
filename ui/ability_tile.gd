extends Control

@onready var label: Label = %Label
@onready var button: Button = %Button
@onready var description: Label = %Description

var ability: Ability


func init(_ability: Ability):
	ability = _ability
	
	label.text = ability.name
	description.text = ability.description
	update_button_text()


func update_button_text():
	var text = "forget - %d" if ability.bought else "study - %d"
	button.text = text % ability.cost


func _on_button_pressed() -> void:
	ability.bought = !ability.bought
	var delta = 1000 * (-ability.cost if ability.bought else ability.cost)
	GameManager.change_time(delta)
	update_button_text()
