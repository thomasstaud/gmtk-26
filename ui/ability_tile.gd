extends Control

@onready var label: Label = %Label
@onready var button: Button = %Button

var ability: Ability


func init(_ability: Ability):
	ability = _ability
	
	label.text = ability.name
	update_button_text()


func update_button_text():
	var text = "sell (%d)" if ability.bought else "buy (%d)"
	button.text = text % ability.cost


func _on_button_pressed() -> void:
	ability.bought = !ability.bought
	update_button_text()
