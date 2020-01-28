extends CanvasLayer

func _ready():
	get_tree().paused = true

func _on_play_play():
	get_tree().paused = false
	queue_free()