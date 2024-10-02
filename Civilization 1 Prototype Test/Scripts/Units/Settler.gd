extends PassiveUnit

func _init() -> void:
	vision_radius = 1

func _ready() -> void:
	defense = 0
	total_movements = 2

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("build") and state == unit_state.PLAYING:
		print("Here's a new city !")
