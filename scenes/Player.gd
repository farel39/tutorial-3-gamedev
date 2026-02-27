extends CharacterBody2D

# --- Node Referensi (Penting untuk Animasi & Crouch) ---
@onready var anim = $AnimatedSprite2D
@onready var stand_shape = $StandShape
@onready var crouch_shape = $CrouchShape

# --- Variabel Pergerakan Dasar ---
@export var gravity = 980.0
@export var walk_speed = 200.0
@export var jump_speed = -400.0

# --- Variabel Double Jump ---
@export var max_jumps = 2
var current_jumps = 0

# --- Variabel Dashing ---
@export var dash_speed = 500.0
@export var dash_duration = 0.2
@export var double_tap_time = 0.25
var dash_timer = 0.0
var is_dashing = false
var last_tap_time = 0.0
var last_tap_direction = 0 

# --- Variabel Crouching ---
@export var crouch_speed = 100.0
var is_crouching = false

func _physics_process(delta: float) -> void:
	# 1. Gravitasi & Reset Lompatan
	if not is_on_floor():
		velocity.y += delta * gravity
	else:
		current_jumps = 0

	# 2. Logika Crouching (Jongkok) yang Benar
	if Input.is_action_pressed("ui_down") and is_on_floor() and not is_dashing:
		is_crouching = true
		stand_shape.disabled = true   # Matikan collision berdiri
		crouch_shape.disabled = false # Nyalakan collision jongkok
	else:
		is_crouching = false
		stand_shape.disabled = false
		crouch_shape.disabled = true

	# 3. Logika Double Jump
	if Input.is_action_just_pressed("ui_up") and not is_crouching:
		if is_on_floor() or current_jumps < max_jumps:
			velocity.y = jump_speed
			current_jumps += 1

	# 4. Input Arah & Deteksi Dashing
	var direction = 0
	if Input.is_action_just_pressed("ui_right"):
		direction = 1
		_check_dash(direction)
	elif Input.is_action_just_pressed("ui_left"):
		direction = -1
		_check_dash(direction)
		
	if Input.is_action_pressed("ui_right"): direction = 1
	elif Input.is_action_pressed("ui_left"): direction = -1

	# 5. Timer Dash
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	var current_speed = walk_speed
	
	if is_crouching:
		current_speed = crouch_speed
	elif is_dashing:
		current_speed = dash_speed
		velocity.y = 0 # Dash melayang lurus

	if direction != 0:
		velocity.x = direction * current_speed
		
		anim.flip_h = (direction < 0) 
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	move_and_slide()
	_update_animation(direction) 


func _check_dash(dir: int) -> void:
	var current_time = Time.get_unix_time_from_system()
	if dir == last_tap_direction and (current_time - last_tap_time) <= double_tap_time:
		is_dashing = true
		dash_timer = dash_duration
	last_tap_time = current_time
	last_tap_direction = dir

func _update_animation(direction: int) -> void:
	if is_dashing:
		anim.play("dash") 
	elif is_crouching:
		anim.play("crouch")
	elif not is_on_floor():
		anim.play("jump")
	elif direction != 0:
		anim.play("walk")
	else:
		anim.play("idle")
