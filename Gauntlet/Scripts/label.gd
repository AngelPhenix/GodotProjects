extends Label

func _ready():
	$tween.interpolate_property(self, "rect_position", rect_position, rect_position + Vector2(0,-10), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()

func _on_tween_tween_completed(object, key):
	queue_free()