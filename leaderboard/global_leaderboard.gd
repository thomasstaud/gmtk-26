extends Node


func _ready() -> void:
  SilentWolf.configure({
	"api_key": "0xf6LCptcL2br97IAmQFj8CpU7CuYgZV1vL2FlDp",
	"game_id": "spellcheck",
	"log_level": 1
  })

  SilentWolf.configure_scores({
	"open_scene_on_close": "res://scenes/MainPage.tscn"
  })
