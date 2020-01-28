extends Node2D

func start(pos):
	position = pos
	$particle.emitting = true

func _process(delta):
	if $particle.emitting == false:
		queue_free()
