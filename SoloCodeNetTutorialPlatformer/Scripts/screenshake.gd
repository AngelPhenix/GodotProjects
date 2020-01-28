extends Node2D

onready var camera = get_parent()
var old_position = Vector2()
var amplitude = 0

func start(amplitude, frequency, duration):
	old_position = camera.offset
	self.amplitude = amplitude
	$frequency.wait_time = duration / frequency
	$duration.wait_time = duration
	$duration.start()
	$frequency.start()
	shake(true)

func shake(on_off):
	var pos = Vector2()
	if !on_off:
		pos = old_position
	else:
		randomize()
		pos = Vector2(rand_range(-amplitude, amplitude), rand_range(-amplitude, amplitude))
	
	$tween.interpolate_property(camera, "offset", camera.offset, pos, $frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$tween.start()

func _on_duration_timeout():
	$frequency.stop()
	$duration.stop()
	shake(false)

func _on_frequency_timeout():
	shake(true)