extends Area2D

const SPEED = 1200
const DAMAGE = 35

var velocity = Vector2()

func _physics_process(delta):
	translate(velocity * delta)
	$AnimatedSprite.play("Shadowball")

func set_direction(direction):
	velocity = direction
	velocity = velocity * SPEED
	if direction.x < 0:
		$AnimatedSprite.scale.x = -1


#TODO: hit registration here
func _on_Shadowball_body_entered(body):
	if body.name == "Player":
		return
	
	if "Enemy" in body.name:
		body.take_damage(DAMAGE)
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
