extends "res://Scripts/Constructors/Enemy.gd"

export var wait_timer_seconds: float
export var walk_timer_seconds: float

func _ready() -> void:
	move_speed = 120
	direction = 1
	health = 4
	$WalkTimer.wait_time = walk_timer_seconds
	$WaitTimer.wait_time = wait_timer_seconds
#	weight = 0.8
	var sprite_height = ($sprite as Sprite).texture.get_height() / 2 + 1

func _physics_process(delta: float) -> void:
	velocity.y += gravity
	if is_on_floor():
		velocity.x = direction * move_speed
	
	velocity = move_and_slide(velocity, Vector2(0,-1))
	
	if is_on_wall():
		reverse()

func reverse() -> void:
	direction *= -1


func _on_WalkTimer_timeout():
	move_speed = 0
	direction *= -1
	$WaitTimer.start()

func _on_WaitTimer_timeout():
	move_speed = 120
	$WalkTimer.start()
