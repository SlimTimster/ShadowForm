extends KinematicBody2D

const GRAVITY = 35
const SPEED = 200  #Player is 250
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var direction = 1  # -> right
var health = 100
var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(_delta):
	if is_dead:
		return
	
	$AnimatedSprite.play("walk")
	velocity.x = SPEED * direction
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall():
		$RayCast2D.position.x *= -1
		direction = direction * -1

	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1
	
	if direction > 0: #walking to the right
		$AnimatedSprite.flip_h = false
	else:             #walking to the left
		$AnimatedSprite.flip_h = true


func take_damage(damage : int):
	health = health - damage
	if health <= 0:
		dead()

func dead():
	velocity = Vector2(0, 0)
	is_dead = true
	$AnimatedSprite.play("dead")
	$CollisionShape2D.set_deferred("disabled", true)
	$Timer.start()

func _on_Timer_timeout():  #called 5s after Enemy died
	queue_free()
