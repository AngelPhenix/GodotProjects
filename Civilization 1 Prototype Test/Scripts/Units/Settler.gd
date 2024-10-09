extends PassiveUnit

onready var city_scn: PackedScene = preload("res://Scenes/City.tscn")
onready var world = get_tree().get_nodes_in_group("world")[0]

func _init() -> void:
	vision_radius = 1

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("build") and state == unit_state.PLAYING:
		build_city(position)

func build_city(settlers_position: Vector2) -> void:
	if world.has_method("city_prompt"):
		world.city_prompt()
		
		for city in get_tree().get_nodes_in_group('city'):
			if position == city.position:
				return
		var new_city: Node = city_scn.instance()
		new_city.civ_color = civ_color
		new_city.civ_name = civ_name
		new_city.modulate = civ_color
		new_city.position = settlers_position
		get_tree().get_nodes_in_group("world")[0].get_node(civ_name).get_node("Cities").add_child(new_city)
		killed()
	
	else:
		print("The World object doesn't have a city_prompt method.")
