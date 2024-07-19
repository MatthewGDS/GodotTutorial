extends CharacterBody2D

const ACCELERATION = 100
const FRICTION = 1100
const MAX_SPEED = 300

enum {
	MOVE,
	ROLL,
	ATTACK
} 

var speed = Vector2.ZERO
var swing : bool = false
var state = MOVE
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree

func _ready():
	animationTree.active = true
	
func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			set_swing(true)
			

		
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO and not swing:
		set_walking(true)
		update_blend_position(input_vector)
		speed = speed.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		set_walking(false)
		speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = speed
	move_and_slide()
	
	if Input.is_action_just_pressed("swing"):
		state = ATTACK
		
		
func set_swing(value = false):
	velocity = Vector2.ZERO
	swing = value
	animationTree.set("parameters/conditions/swing", value)
	state = MOVE
	
func set_walking(value):
	animationTree.set("parameters/conditions/isRunning", value)
	animationTree.set("parameters/conditions/idle", not value)
	
func update_blend_position(direction):
	animationTree["parameters/Idle/blend_position"] = direction
	animationTree["parameters/Run/blend_position"] = direction
	animationTree["parameters/Attack/blend_position"] = direction

		
	

