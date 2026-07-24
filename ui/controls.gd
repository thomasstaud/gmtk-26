class_name Controls
extends Node

@onready var dash_cooldown: TextureProgressBar = $DashCooldown


func dash(cooldown: int) -> void:
	dash_cooldown.value = 100
	var tween = get_tree().create_tween()
	tween.tween_property(dash_cooldown, "value", 0, cooldown)
