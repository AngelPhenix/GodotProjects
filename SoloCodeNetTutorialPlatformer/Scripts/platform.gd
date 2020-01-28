extends RigidBody2D

export (int) var duration = 1
export var distance = Vector2()

func _ready():
	move()
	
func move():
	$tween.interpolate_property(self,"position",global_position,global_position + distance, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$tween.start()

func _on_tween_tween_completed(object, key):
	distance *= -1
	move()