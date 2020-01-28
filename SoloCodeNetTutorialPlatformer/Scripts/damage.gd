extends Node2D

func init(pos, value):
	position = pos
	$Label.text =  " - " + str(int(value))
	
	$Tween.interpolate_property(
		self, 
		"position", 
		Vector2(position.x -32, position.y -32), 
		Vector2(position.x -32, position.y -52), 
		0.6, 
		Tween.TRANS_SINE, 
		Tween.EASE_IN)
	
	$Tween.interpolate_property(
		self, 
		"modulate", 
		Color(1,1,1,1), 
		Color(1,1,1,0), 
		0.2, 
		Tween.TRANS_BACK, 
		Tween.EASE_IN_OUT, 
		0.4)
	
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	queue_free()
