extends Camera2D

var amplitude: float

func _process(delta: float) -> void:
	offset = Vector2(rand_range(-amplitude, amplitude), rand_range(-amplitude, amplitude))

func _on_shake_duration_timeout():
	set_process(false)