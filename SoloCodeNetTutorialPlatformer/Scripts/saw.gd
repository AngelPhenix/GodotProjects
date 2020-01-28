extends "res://Scripts/const_enemy.gd"

func _ready():
	resist = 1.8
	strength = 3

func _physics_process(delta):
	velocity.x = direction * speed
	velocity.y = 50
	
	velocity = move_and_slide(velocity, Vector2(0,-1))
	
	if is_on_wall() || !$raycast.is_colliding():
		direction = -direction
		$raycast.position.x = -$raycast.position.x