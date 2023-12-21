extends KinematicBody2D

var velocity: Vector2 = Vector2()
var gravity: float = 1200
var speed: float = 1400
var max_jump_height: float = 2.5 * Globals.UNIT_SIZE
var min_jump_height: float = 0.3 * Globals.UNIT_SIZE
var jump_duration: float = 0.3
var max_jump_velocity: float
var min_jump_velocity: float
var dead: bool = false
var wait: bool = true


func _ready() -> void:
	$AnimationPlayer.play('idle')
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)


# Constant Gravity applied to character
# For the Gravity not to add up to absurd amount
func _physics_process(delta: float) -> void:
	if !dead && !wait:
		velocity.y += gravity * delta
		if velocity.x < speed:
			velocity.x += 5
		velocity = move_and_slide(velocity, Vector2(0, -1))
		$AnimationPlayer.play('run')


# Player input (Jump while on floor / Release mid-air)
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") && is_on_floor():
		velocity.y = max_jump_velocity
	
	if event.is_action_released("jump") && velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity
	
	if event.is_action_pressed("start"):
		wait = false


# Player dies when out of screen, sent to be recovered by the World.gd script
func _on_VisibilityNotifier2D_screen_exited() -> void:
	dead = true
