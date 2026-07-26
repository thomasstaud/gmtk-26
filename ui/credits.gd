extends Control

@onready var leaderboard: Button = %Leaderboard


func _ready() -> void:
	leaderboard.visible = GameManager.is_leaderboard_unlocked()


func _on_leaderboard_pressed() -> void:
	GameManager.to_leaderboard()


func _on_menu_pressed() -> void:
	GameManager.to_level_select()
