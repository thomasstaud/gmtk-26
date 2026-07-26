extends Control

@onready var leaderboard: Control = %Leaderboard
@onready var time: Label = %Time

func _ready() -> void:
	time.text = UI.format_ms(GameManager.final_time())
	leaderboard.init("total", GameManager.final_time())


func _on_menu_pressed() -> void:
	GameManager.to_level_select()
