extends RigidBody2D

var health = 3

func init(pos):
	global_position = pos

func hit(value):
	health -= 1
	update()

func update():
	match health:
		2: $sprite.frame = 1
		1: $sprite.frame = 2
		0: queue_free()