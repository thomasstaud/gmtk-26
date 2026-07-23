class_name Player
extends CharacterBody3D

const BOMB = preload("uid://dff0rnn50u2q1")

const MIN_PITCH: float = -89.9
const MAX_PITCH: float = 75
const SPEED = 10.0
const JUMP_POWER = 10.0
const LERP_VAL = .5
const PUSH_FORCE = 2.0

const JUMP_GRAVITY = 3.0
const JUMP_HOLD_GRAVITY = 1.0

const WALL_SLIDE_GRAVITY = 0.5

const DASH_FORCE = 35.0
const DASH_DURATION = 0.15
const DASH_COOLDOWN = 1.0

const BOMB_COOLDOWN = 0.2


@export var sensitivity = 0.2
@export var max_jump_count := 2

var can_move := false
var speed_mult: float
var jump := false
var gravity_multiplier := 1.0
var jump_count := 0

var is_dashing := false
var dash_timer := 0.0
var can_dash := true
var can_bomb := true

@export var pcam: PhantomCamera3D
@onready var player_model: Node3D = $Model
@onready var head: Node3D = $Head
@onready var bomb_spawn: Node3D = %BombSpawn


func _ready() -> void:
	GameManager.player = self


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and AbilityManager.jump.bought:
		if is_on_floor() or jump_count < max_jump_count-1 or is_on_wall():
			jump = true
	
	if event.is_action_pressed("dash"):
		if not is_dashing and can_move and can_dash and AbilityManager.dash.bought:
			is_dashing = true
			can_dash = false
			dash_timer = DASH_DURATION
			get_tree().create_timer(DASH_COOLDOWN).timeout.connect(func(): can_dash = true)
	
	if event.is_action_pressed("bomb"):
		if can_bomb and AbilityManager.bomb.bought:
			can_bomb = false
			var bomb = BOMB.instantiate()
			bomb_spawn.add_child(bomb)
			bomb.explode()
			get_tree().create_timer(BOMB_COOLDOWN).timeout.connect(func(): can_bomb = true)
	
	if event.is_action_pressed("pause"):
		GameManager.paused = true

func _unhandled_input(event) -> void:
	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		GameManager.paused = false
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var pcam_rotation_degrees: Vector3
		
		pcam_rotation_degrees = pcam.rotation_degrees
		pcam_rotation_degrees.x -= event.relative.y * sensitivity
		pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, MIN_PITCH, MAX_PITCH)
		pcam_rotation_degrees.y -= event.relative.x * sensitivity
		
		pcam.rotation_degrees = pcam_rotation_degrees
		rotation_degrees.y = pcam_rotation_degrees.y
		head.global_rotation_degrees = pcam.rotation_degrees


func _physics_process(delta: float) -> void:
	# inputs
	if can_move:
		if Input.is_action_pressed("jump"):
			gravity_multiplier = JUMP_HOLD_GRAVITY
		else:
			gravity_multiplier = JUMP_GRAVITY

	# Dash logic
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			return 
		else:
			var dash_direction = -pcam.global_transform.basis.z.normalized()
			velocity = dash_direction * DASH_FORCE
			move_and_slide()
			return

	
	if not is_on_floor():
		if is_on_wall() and not is_dashing and velocity.y <= 0:
			# Apply reduced gravity for wall sliding.
			velocity += get_gravity() * WALL_SLIDE_GRAVITY * delta
		else:
			# Apply normal gravity.
			velocity += get_gravity() * gravity_multiplier * delta
	
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := quaternion * Vector3(input_dir.x, 0, input_dir.y)
	direction.y = 0
	direction = direction.normalized()
	speed_mult = 1.0
	
	if jump:
		jump = false
		if is_on_floor():
			
			velocity.y = JUMP_POWER
			jump_count += 1
		elif is_on_wall():
			print("walljump")
			# Wall jump velocity: upward and away from the wall.
			velocity = -direction * JUMP_POWER + Vector3.UP * JUMP_POWER
			
		else:
			# If not on floor or wall, perform a regular double jump.
			velocity.y = JUMP_POWER
			jump_count += 1
		
	if is_on_floor():
		jump_count = 0
	else:
		speed_mult = 0.5
	
	
	if not can_move:
		direction = Vector3.ZERO
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED * speed_mult, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * SPEED * speed_mult, LERP_VAL)
	else:
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
			velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
	
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_force(-c.get_normal()*PUSH_FORCE)


func _on_finish_detection_area_entered(_area: Area3D) -> void:
	GameManager.on_win()
