extends Area2D

var button_pressed: StreamTexture = preload("res://Sprites/interru_close.png")
var closed: bool = false
signal open_door

func _on_Button_body_entered(body: Object) -> void:
	if body.is_in_group("player") && !closed:
		$sprite.texture = button_pressed
		closed = true
		$audio.play()
		emit_signal("open_door")