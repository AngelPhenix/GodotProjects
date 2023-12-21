extends KinematicBody2D

var direction: Vector2
var last_direction: Vector2 = Vector2(0,1)
var speed: int = 400
var start_position: Vector2
var life: int = 5 setget _update_life

var can_teleport: bool = true

signal health_changed
signal shoot(direction)

func _physics_process(_delta):
	if Input.is_action_pressed("ui_right"):
		direction = Vector2(1,0)
		last_direction = direction
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2(-1,0)
		last_direction = direction
	elif Input.is_action_pressed("ui_up"):
		direction = Vector2(0,-1)
		last_direction = direction
	elif Input.is_action_pressed("ui_down"):
		direction = Vector2(0,1)
		last_direction = direction
	else :
		direction = Vector2.ZERO

	move_and_slide(direction * speed, Vector2(0,-1))


func _input(event):
	if Input.is_action_just_pressed("shoot"):
		_shoot()


func _update_life(remaining_life) -> void:
	life = remaining_life
	emit_signal("health_changed", remaining_life)
	
	if life <= 0:
		print("Player lost the game ! Should send a restart popup now. At least a title screen")


func fall() -> void:
	var tween: Tween = Tween.new()
	tween.interpolate_property(self, "scale", scale, scale - scale, 0.4, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	add_child(tween)
	tween.start()
	set_physics_process(false)
	yield(tween, "tween_completed")
	scale = Vector2(1,1)
	position = start_position
	self.life -= 1
	set_physics_process(true)


# Signal sent to the World for it to create a bullet as its child
# Giving the bullet the right direction (direction of the player)
func _shoot() -> void:
	emit_signal("shoot", last_direction)
