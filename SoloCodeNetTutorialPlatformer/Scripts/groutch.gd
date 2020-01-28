extends "res://Scripts/const_enemy.gd"

func _ready():
	resist = 1.3
	strength = 1

func _physics_process(delta):
	movement_loop()
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2(0,-1))

func movement_loop():
	if is_on_wall():
		direction = -direction
	
	if direction == 1:
		velocity.x = speed
		$sprite.flip_h = false
		animation_loop("walk")
	elif direction == -1:
		velocity.x = -speed
		$sprite.flip_h = true
		animation_loop("walk")
	else:
		velocity.x = 0
		animation_loop("idle")

func animation_loop(animation):
	if $anim.current_animation != animation:
		$anim.play(animation)

func _on_time_timeout():
	var random_move = int(rand_range(0, 10))
	if random_move < 5:
		direction = -1
	elif random_move > 5:
		direction = 1
	else: 
		direction = 0