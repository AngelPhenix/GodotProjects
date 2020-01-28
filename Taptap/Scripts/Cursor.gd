extends Area2D

var bubble_spotted: Array = []

func _physics_process(delta: float) -> void:
	position = get_global_mouse_position()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pop") && bubble_spotted.size() > 0:
		for bubble in bubble_spotted:
			if bubble == bubble_spotted.back():
				get_parent().popped(bubble)
				bubble.queue_free()
	elif Input.is_action_just_pressed("pop") && bubble_spotted.size() == 0:
		get_parent().missed()

func _on_Cursor_area_entered(area: Area2D) -> void:
	if area is Bubble:
		bubble_spotted.append(area)

func _on_Cursor_area_exited(area: Area2D) -> void:
	if area is Bubble:
		bubble_spotted.pop_back()