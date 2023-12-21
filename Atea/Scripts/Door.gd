extends StaticBody2D

func interaction(duration: float = 2.0) -> void:
	($tween as Tween).interpolate_property(self, "position:y", position.y, position.y - 150, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	($tween as Tween).start()