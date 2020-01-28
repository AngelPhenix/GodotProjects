extends StaticBody2D


func _on_Button_open_door() -> void:
	$sprite.modulate = Color(0.5,0.5,0.5,1)
	$sprite2.modulate = Color(0.5,0.5,0.5,1)
	$sprite3.modulate = Color(0.5,0.5,0.5,1)
	$shape.set_deferred("disabled", true)