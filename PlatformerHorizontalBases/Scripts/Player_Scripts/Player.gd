extends KinematicBody2D
class_name PlayerController

var move_speed: int = 700
var gravity: int = 2000
var jump_velocity: int = -800
var jump_count: int = 0
var max_jump_count: int = 2
var velocity: Vector2 = Vector2()
var shaking: bool = false
var move_loop_state: bool = true
var dashing: bool = false
var direction: int = 1
var talking: bool = false

export var dash_time: float = 0.1

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("dash"):
		dashing = true
		$dash_timer.wait_time = dash_time
		$dash_timer.start()

	if dashing:
		velocity.x = (direction * move_speed) * 3 
	else:
		velocity.y += gravity * delta
		movement_loop(move_loop_state)
	velocity = move_and_slide(velocity, Vector2(0,-1))

func movement_loop(state) -> void:
	# If the movement_loop is true (99% of the time) the player can move freely
	# if the movement_loop is false (for interactions) the player won't be able to move and will "fall" to the floor.
	if state:
		if Input.is_action_pressed("right"):
			direction = 1
			velocity.x = move_speed
			$weapon_pos.position.x = 35
			get_node("weapon_pos/Weapon/sprite").flip_h = false
		elif Input.is_action_pressed("left"):
			direction = -1
			velocity.x = -move_speed
			$weapon_pos.position.x = -35
			get_node("weapon_pos/Weapon/sprite").flip_h = true
		else:
			velocity.x = 0
	
		if Input.is_action_just_pressed("attack"):
			get_node("weapon_pos/Weapon/anim").play("Sword_slash")

		if is_on_floor():
			jump_count = 0

		if Input.is_action_just_pressed("jump") && Input.is_action_pressed("down"):
			set_collision_mask_bit(2, false)
		elif jump_count < max_jump_count && Input.is_action_just_pressed("jump"):
			jump_count += 1
			velocity.y = jump_velocity
	# If movement_loop has been disabled
	# When interacting while jumping/being in movement, so the player touches the ground and stops
	else:
		velocity.x = 0

func _on_pass_through_body_exited(body: Object) -> void:
	set_collision_mask_bit(2, true)

func _on_dash_timer_timeout():
	dashing = false