extends CharacterBody2D
class_name Player


var game_timer: Timer
@export var player_ui: CanvasLayer
@export_category("Upgrades")
@export var upgrade_arr: Array[Upgrade]


@export_category("Movement")
@export var CoyoteTimer : Timer
@export var JumpBufferTimer : Timer

var coyote_activated: bool = false

const JUMP_HEIGHT: float = -530.0
var gravity: float = 12.0 # putem mari gravitatia daca e prea floaty
const MAX_GRAVITY: float = 14.5
var max_jumps: int = 1
var jumps_done: int = 0

var max_speed: float = 250.0
var acceleration: float = 30.0
const FRICTION: float = 10.0

#vars for tp dash
var look_dir_x: int = 1
var can_tp: bool = false


func _physics_process(delta: float) -> void:
	var x_input: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var velocity_weight: float = delta * (acceleration if x_input else FRICTION)
	velocity.x = lerp(velocity.x, x_input * max_speed, velocity_weight)
	
	if x_input:
		look_dir_x = int(x_input)
		print(look_dir_x)
	if x_input > 0: # maybe these need to be inside if x_input?
		pass #play walk_right
	elif x_input < 0:
		pass #play walk.flip_h
	
	if is_on_floor():
		jumps_done = 0
		coyote_activated = false
		gravity = lerp(gravity, 12.0, 12.0 * delta)
	else:
		if jumps_done == 0:
			jumps_done += 1
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
	
	if !JumpBufferTimer.is_stopped():
		if is_on_floor() or !CoyoteTimer.is_stopped():
			velocity.y = JUMP_HEIGHT
			jumps_done = 1
			JumpBufferTimer.stop()
			CoyoteTimer.stop()
			coyote_activated = true
		elif jumps_done < max_jumps:
			velocity.y = JUMP_HEIGHT
			jumps_done += 1
			JumpBufferTimer.stop()
			upgrade_arr[0].active_timer.timeout
	
	velocity.y += gravity
	
	move_and_slide()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("one"):
		if upgrade_arr[0].time_price < game_timer.time_left:
			upgrade_arr[0].activate()
			print("1st skill pressed")
	if Input.is_action_just_pressed("two"):
		if upgrade_arr[1].time_price < game_timer.time_left:
			upgrade_arr[1].activate()
			print("2nd skill pressed")
	if Input.is_action_just_pressed("three"):
		if upgrade_arr[2].time_price < game_timer.time_left:
			upgrade_arr[2].activate()
			print("3rd skill pressed")
			
	if can_tp and Input.is_action_just_pressed("teleport_dash"):
		if look_dir_x == 1:
			if %RightRaycast.get_collider() != null and %RightRaycast.get_collider().is_in_group("solid"):
				return
			global_position += %RightRaycast.target_position
		elif look_dir_x == -1:
			if %LeftRaycast.get_collider() != null and %LeftRaycast.get_collider().is_in_group("solid"):
				return
			global_position += %LeftRaycast.target_position
	
