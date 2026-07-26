class_name Bomb
extends Node3D

const EXPLOSION_STRENGTH := 2
const DECAY_FACTOR := 0.08
const DELAY := 2.5

@onready var area: Area3D = $Area3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = %AudioStreamPlayer3D

var targets: Array[RigidBody3D] = []

func fuse():
	get_tree().create_timer(DELAY).timeout.connect(explode)

func explode():
	for body in targets:
		var vec = body.global_position - self.global_position
		var base_impulse = vec.normalized() * EXPLOSION_STRENGTH
		var decay = max(1, (DECAY_FACTOR / vec.length()))
		body.apply_central_impulse(base_impulse * decay)
	audio_stream_player_3d.play()
	$bomb2.hide()
	$MeshInstance3D2.hide()
	get_tree().create_timer(0.5).timeout.connect(func(): queue_free())


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		targets.append(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if not body is RigidBody3D: return
	if body in targets: targets.erase(body)
