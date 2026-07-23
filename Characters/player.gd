extends CharacterBody2D

@export var CoyoteTimer : Timer
@export var JumpBufferTimer : Timer

var coyote_activated: bool = false

const JUMP_HEIGHT: float = -530.0
var gravity: float = 12.0
const MAX_GRAVITY: float = 14.5

var max_speed: float = 250.0
var acceleration: float = 30.0
const FRICTION: float = 10.0

func _physics_process(delta: float) -> void:
	var x_input: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var velocity_weight: float = delta * (acceleration if x_input else FRICTION)
	velocity.x = lerp(velocity.x, x_input * max_speed, velocity_weight)
	
	if x_input > 0:
		pass #play walk_right
	else:
		pass #play walk.flip_h
	
	if is_on_floor():
		coyote_activated = false
		gravity = lerp(gravity, 12.0, 12.0 * delta)
	else:
		if CoyoteTimer.is_stopped() and !coyote_activated:
			CoyoteTimer.start()
			coyote_activated = true
			print("started the coyote")
		
		if Input.is_action_just_released("jump") or is_on_ceiling():
			velocity.y *= 0.5 # mareste pt faster descent after jump
		
		gravity = lerp(gravity, MAX_GRAVITY, 12.0 * delta)
	if Input.is_action_just_pressed("jump"):
		if JumpBufferTimer.is_stopped():
			JumpBufferTimer.start()
			print("jump buffer started")
	
	if !JumpBufferTimer.is_stopped() and (!CoyoteTimer.is_stopped() or is_on_floor()):
		velocity.y = JUMP_HEIGHT
		#to make sure we dont dbl jump(without upgrade):
		JumpBufferTimer.stop()
		CoyoteTimer.stop()
		coyote_activated = true
	
	velocity.y += gravity
	
	move_and_slide()
