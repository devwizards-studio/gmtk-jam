extends CharacterBody2D

@export var speed: float
var dir: int = 1 # so it starts moving right by default
var gravity: float = 12.0

@onready var right_cast: RayCast2D = $RightCast
@onready var left_cast: RayCast2D = $LeftCast
@export var sprite: AnimatedSprite2D

func _ready() -> void:
	right_cast.set_collision_mask_value(3, true)
	left_cast.set_collision_mask_value(3, true)
	sprite.play("walk")


func _physics_process(delta: float) -> void:
	
	if dir == 1 and right_cast.is_colliding():
		sprite.flip_h = true
		dir = -1
		
	elif dir == -1 and left_cast.is_colliding():
		sprite.flip_h = false
		dir = 1
	
	velocity.x = lerp(velocity.x, dir * speed, 10.0 * delta)
	#velocity.x = dir * speed * delta
	velocity.y += gravity
	move_and_slide()
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	#dramatic death
	if body is Player:
		process_mode = Node.PROCESS_MODE_DISABLED
		body.get_node("CollisionShape2D").queue_free()
		#Engine.time_scale = 0.5
		#play on their knees anim
		get_tree().call_deferred("reload_current_scene")
