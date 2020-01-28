extends "res://Scripts/Constructors/Enemy.gd"

func _ready() -> void:
	move_speed = 200
	direction = 1
	health = 4
	weight = 0.8
	var sprite_height = ($sprite as Sprite).texture.get_height() / 2 + 1
	($raycast as RayCast2D).cast_to = Vector2(0, sprite_height)

func _physics_process(delta: float) -> void:
	velocity.y += gravity
	if is_on_floor():
		velocity.x = direction * move_speed
		
		if !($raycast as RayCast2D).is_colliding():
			reverse()
	
	velocity = move_and_slide(velocity, Vector2(0,-1))
	if is_on_wall():
		reverse()

func reverse() -> void:
	($raycast as RayCast2D).position.x *= -1
	direction *= -1