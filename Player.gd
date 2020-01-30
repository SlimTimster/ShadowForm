extends KinematicBody2D

const SPEED = 250
const JUMP_POWER = -550
const GRAVITY = 35
const FLOOR = Vector2(0,-1)
const SHADOWBALL = preload("res://Shadowball.tscn")

var actual_gravity
var on_ground = false
var doublejump_available = true

var sprite_scale
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_scale = $Sprite.scale.x
	actual_gravity = GRAVITY
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	
#------------------------- Movement ----------------------------
	if Input.is_action_pressed("move_right"):
		velocity.x = SPEED
		$Sprite.scale.x = sprite_scale
	elif Input.is_action_pressed("move_left"):
		velocity.x = -SPEED
		$Sprite.scale.x = - sprite_scale
	else:
		velocity.x = 0
		
	if Input.is_action_just_pressed("move_jump"):
		if doublejump_available == true:
			velocity.y = JUMP_POWER
			doublejump_available = false
		elif on_ground == true:
			velocity.y = JUMP_POWER
	
	if velocity.y < -150:
		actual_gravity = 20
	else:
		actual_gravity = GRAVITY

	velocity.y += actual_gravity
	
	if is_on_floor():
		on_ground = true
		doublejump_available = true
	else:
		on_ground = false

	velocity = move_and_slide(velocity, FLOOR)
	
#------------------------- Shooting ----------------------------	
	if Input.is_action_just_pressed("shoot_right") or Input.is_action_just_pressed("shoot_left"):
		var shadowball = SHADOWBALL.instance()
		get_parent().add_child(shadowball)
		
		if Input.is_action_just_pressed("shoot_right"):
			shadowball.set_direction(Vector2(1,0))
			shadowball.position = position + Vector2(50, 10)
		else: 
			shadowball.set_direction(Vector2(-1, 0))
			shadowball.position = position + Vector2(-50, 10)
