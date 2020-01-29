extends KinematicBody2D

var state_machine
var velocity = Vector2.ZERO
var sprite_scale
var on_ground

const GRAVITY = 10 
const SPEED = 100
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	sprite_scale = $Sprite.scale.x

func _physics_process(delta):
	var current = state_machine.get_current_node()
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$Sprite.scale.x = sprite_scale
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$Sprite.scale.x = -sprite_scale
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("ui_up") and on_ground == true:
		velocity.y = JUMP_POWER
		state_machine.travel("jump")
	
	
	velocity.y += GRAVITY
	
	if velocity.x == 0:
		state_machine.travel("idle")
	
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
	
	velocity = move_and_slide(velocity, FLOOR)
