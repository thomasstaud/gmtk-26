class_name Controls
extends Node

@onready var dash_cooldown: TextureProgressBar = $DashCooldown
@onready var bomb: Label = %Bomb

func _ready() -> void:
	update_visibility()

func update_visibility() -> void:
	dash_cooldown.visible = AbilityManager.dash.bought
	bomb.visible = AbilityManager.bomb.bought

func dash(cooldown: int) -> void:
	if not dash_cooldown.visible:
		return
		
	dash_cooldown.value = 100
	var tween = get_tree().create_tween()
	tween.tween_property(dash_cooldown, "value", 0, cooldown)
