extends RigidBody2D

var velocity = Vector2()
var speed = 500
var explosion = false

signal explode

func start(pos, angle):
	position = pos
	velocity = Vector2(speed, 0).rotated(angle)
	apply_impulse(pos, velocity) 

func _on_Timer_timeout():
	explosion = true
	set_collision_mask_bit(0, false)
	$anim.play("explode")
	emit_signal("explode")
	yield($anim, "animation_finished")
	queue_free()

func _on_Bomb_body_entered(body):
	if explosion:
		if body.has_method("hit"):
			body.hit(200)