extends Node3D

const EXPLOSION_STRENGTH := 2.5
const DELAY := 0.2

@onready var area: Area3D = $Area3D

func explode():
	get_tree().create_timer(DELAY).timeout.connect(func(): queue_free())


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		var vec = body.global_position - self.global_position
		body.apply_central_impulse(vec * EXPLOSION_STRENGTH)
