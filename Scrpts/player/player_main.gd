extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -500.0
const DASH_SPEED = 400.0
const DASH_TIME = 0.2


@onready var _animated_sprite = $AnimatedSprite2D
@onready var dash_timer = $DashTimer

var is_dashing = false
var dash_direction = Vector2.ZERO
var have_dash = 1
var have_dash_base = 1
var dash_vel = 0.9

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta
		
	if is_on_floor():
		have_dash = have_dash_base
		
		
	if is_dashing:
		velocity = dash_direction * DASH_SPEED
	else:
		var direction = Input.get_axis("left_run", "right_run")
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		if Input.is_action_just_pressed("dash") and have_dash >= 1 and not is_dashing:
			have_dash -= 1
			start_dash()
			
	move_and_slide() 
	animations()


func start_dash():
	is_dashing = true
	dash_direction = Vector2.ZERO

	if Input.is_action_pressed("left_run"):
		dash_direction.x = -dash_vel
	elif Input.is_action_pressed("right_run"):
		dash_direction.x = dash_vel

	if Input.is_action_pressed("jump"):
		dash_direction.y = -dash_vel
	elif Input.is_action_pressed("down"):
		dash_direction.y = dash_vel
	
	if dash_direction == Vector2.ZERO:
		dash_direction.x = -1 if _animated_sprite.flip_h else 1
	
	dash_timer.start(DASH_TIME)


func animations():
	if Input.is_action_just_pressed("attac"):
		_animated_sprite.play("knock")
	
	if Input.is_action_just_pressed("shield"):
		_animated_sprite.play("shield")	
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("jump") and is_on_floor() == false:
		if Input.is_action_pressed("right_run"):
			_animated_sprite.flip_h = false
		if Input.is_action_pressed("left_run"):
			_animated_sprite.flip_h = true
		_animated_sprite.play("jump")
		
	elif Input.is_action_just_released("jump"):
		_animated_sprite.pause()
		
	elif Input.is_action_pressed("right_run"):
		_animated_sprite.flip_h = false
		if is_on_floor():
			_animated_sprite.play("run")
			
	elif Input.is_action_pressed("left_run"):
		_animated_sprite.flip_h = true
		if is_on_floor():
			_animated_sprite.play("run")
			
	else: 
		_animated_sprite.play("idle")


func _on_DashTimer_timeout():
	is_dashing = false
