extends Label

signal play

func callback():
	emit_signal("play")