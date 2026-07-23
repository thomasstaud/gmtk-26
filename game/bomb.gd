class_name Bomb
extends Node3D

const EXPLOSION_STRENGTH := 3
const DELAY := 2.5

@onready var area: Area3D = $Area3D

var targets: Array[RigidBody3D] = []

func fuse():
	get_tree().create_timer(DELAY).timeout.connect(explode)

func explode():
	for body in targets:
		var vec = body.global_position - self.global_position
		body.apply_central_impulse(vec * EXPLOSION_STRENGTH)
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		targets.append(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if not body is RigidBody3D: return
	if body in targets: targets.erase(body)
