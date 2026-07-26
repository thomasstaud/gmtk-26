class_name Player
extends CharacterBody3D

signal dashed

const BOMB = preload("uid://dff0rnn50u2q1")

const MIN_PITCH: float = -89.9
const MAX_PITCH: float = 75.0
const SPEED = 10.0
const JUMP_POWER = 13.5
const PUSH_FORCE = 2.0
const CLIMB_POWER = 5.5

const GROUND_ACCEL = 40.0
const AIR_ACCEL = 6.0
const GROUND_DECEL = 12.0
const DASH_DECAY = 2.0

const JUMP_GRAVITY = 4.3
const JUMP_HOLD_GRAVITY = 3.3
const WALL_SLIDE_GRAVITY = 3.0

# Gleit-Anpassungen
const GLIDE_TERMINAL_VELOCITY = -2.5
const GLIDE_SMOOTHING = 12.0

const DASH_FORCE = 35.0
const DASH_VERTICAL_SCALE = 0.25
const DASH_DURATION = 0.17
const DASH_COOLDOWN = 1.0
const BOMB_COOLDOWN = 0.2

const COYOTE_TIME = 0.15 
var coyote_timer := 0.0

@export var sensitivity = 0.2
@export var max_jump_count := 2


@export var sound_jump: AudioStream
@export var sound_double_jump: AudioStream
@export var sound_dash: AudioStream
@export var sound_bomb: AudioStream
@export var sound_climb: AudioStream
@export var sound_footstep: AudioStream
@export var sound_glide: AudioStream
@export var footstep_interval: float = 0.2
var footstep_timer: float = 0.0

var can_move := false
var jump := false
var jump_count := 0
var climb := false
var glide := false
var was_gliding := false

var is_dashing := false
var dash_timer := 0.0
var can_dash := true
var can_bomb := true

@export var pcam: PhantomCamera3D
@onready var head: Node3D = $Head
@onready var bomb_spawn: Node3D = %BombSpawn
@onready var forward_area: Area3D = $ForwardArea
@onready var audio_player: AudioStreamPlayer3D = $AudioPlayer 



func _ready() -> void:
	GameManager.player = self


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and AbilityManager.jump.bought:
		if is_on_floor() or coyote_timer > 0.0:
			jump = true
		elif jump_count < max_jump_count and velocity.y >= -1.0:
			jump = true
			
	if event.is_action_pressed("dash"):
		if not is_dashing and can_move and can_dash and AbilityManager.dash.bought:
			is_dashing = true
			can_dash = false
			dash_timer = DASH_DURATION
			dashed.emit(DASH_COOLDOWN)
			
			
			play_sound(sound_dash)
			
			get_tree().create_timer(DASH_COOLDOWN).timeout.connect(func(): can_dash = true)
		
	if event.is_action_pressed("bomb"):
		if can_bomb and AbilityManager.bomb.bought:
			can_bomb = false
			var bomb: Bomb = BOMB.instantiate()
			get_parent().add_child(bomb)
			bomb.position = bomb_spawn.global_position
			bomb.fuse()
			
			
			play_sound(sound_bomb)
			
			get_tree().create_timer(BOMB_COOLDOWN).timeout.connect(func(): can_bomb = true)
	
	if event.is_action_pressed("pause"):
		GameManager.paused = true


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			GameManager.paused = false

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var pcam_rotation_degrees: Vector3 = pcam.rotation_degrees
		pcam_rotation_degrees.x -= event.relative.y * sensitivity
		pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, MIN_PITCH, MAX_PITCH)
		pcam_rotation_degrees.y -= event.relative.x * sensitivity
		
		pcam.rotation_degrees = pcam_rotation_degrees
		rotation_degrees.y = pcam_rotation_degrees.y
		head.global_rotation_degrees = pcam.rotation_degrees


func _physics_process(delta: float) -> void:
	var is_holding_jump := Input.is_action_pressed("jump")
	var is_holding_forward := Input.is_action_pressed("forward")
	
	climb = can_move and AbilityManager.climb.bought and is_holding_forward and forward_area.has_normal_overlapping_bodies()
	glide = AbilityManager.glide.bought and not is_on_floor() and not climb and is_holding_jump and velocity.y < 0
	
	if glide and not was_gliding:
		play_sound(sound_glide)
	was_gliding = glide
	
	if is_on_floor():
		jump_count = 0
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta 

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
		else:
			var dash_direction = -pcam.global_transform.basis.z.normalized()
			dash_direction.y *= DASH_VERTICAL_SCALE
			velocity = dash_direction * DASH_FORCE
			move_and_slide()
			return

	if not is_on_floor() and not climb:
		if glide:
			velocity.y = lerp(velocity.y, GLIDE_TERMINAL_VELOCITY, GLIDE_SMOOTHING * delta)
		elif is_on_wall() and velocity.y <= 0:
			velocity += get_gravity() * WALL_SLIDE_GRAVITY * delta
		else:
			var grav_mult := JUMP_GRAVITY
			if velocity.y > 0 and is_holding_jump:
				grav_mult = JUMP_HOLD_GRAVITY
			velocity += get_gravity() * grav_mult * delta

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := quaternion * Vector3(input_dir.x, 0, input_dir.y)
	direction.y = 0
	direction = direction.normalized()

	if not can_move:
		direction = Vector3.ZERO

	if jump and not climb:
		jump = false
		if is_on_floor() or coyote_timer > 0.0:
			velocity.y = JUMP_POWER
			jump_count = 1
			coyote_timer = 0.0 
			var random_pitch = randf_range(0.9, 1.1)
			play_sound(sound_jump,random_pitch)
		elif is_on_wall():
			velocity = -direction * JUMP_POWER + Vector3.UP * JUMP_POWER
			play_sound(sound_jump)
		elif jump_count < max_jump_count:
			velocity.y = JUMP_POWER
			jump_count += 1
			play_sound(sound_double_jump)
			
	if climb:
		velocity.y = CLIMB_POWER
		footstep_timer -= delta
		if footstep_timer <= 0:
			var random_pitch = randf_range(0.9, 1.1)
			play_sound(sound_climb,random_pitch)
			footstep_timer = footstep_interval*2

	var horiz_vel := Vector3(velocity.x, 0, velocity.z)
	var current_speed := horiz_vel.length()
	var accel := GROUND_ACCEL if is_on_floor() else AIR_ACCEL

	if direction != Vector3.ZERO:
		var clamped_speed = min(SPEED, current_speed + delta * accel)
		horiz_vel = clamped_speed * direction
		
		if horiz_vel.length() > SPEED:
			var new_speed := move_toward(horiz_vel.length(), SPEED, DASH_DECAY * SPEED * delta)
			horiz_vel = horiz_vel.normalized() * new_speed
			
		if is_on_floor():
			footstep_timer -= delta
			if footstep_timer <= 0:
				var random_pitch = randf_range(0.8, 1.2)
				play_sound(sound_footstep, random_pitch)
				footstep_timer = footstep_interval
	else:
		horiz_vel = horiz_vel.lerp(Vector3.ZERO, GROUND_DECEL * delta)

	velocity.x = horiz_vel.x
	velocity.z = horiz_vel.z

	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_force(-c.get_normal() * PUSH_FORCE)


func play_sound(stream: AudioStream, pitch: float = 1.0) -> void:
	if stream and audio_player:
		audio_player.stream = stream
		audio_player.pitch_scale = pitch
		audio_player.play()


func _on_finish_detection_area_entered(_area: Area3D) -> void:
	GameManager.on_win()
