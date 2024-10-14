extends PassiveUnit

onready var city_scn: PackedScene = preload("res://Scenes/City.tscn")
onready var city_name_popup = get_tree().get_nodes_in_group("built_city_popup")[0]

func _init() -> void:
	vision_radius = 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("build") and state == unit_state.PLAYING:
		build_city(position)

func build_city(settlers_position: Vector2) -> void:
	for city in get_tree().get_nodes_in_group('city'):
		if position == city.position:
			return
	var new_city: Node = city_scn.instance()
	new_city.civ_color = civ_color
	new_city.civ_name = civ_name
	new_city.modulate = civ_color
	new_city.position = settlers_position
	get_tree().get_nodes_in_group("world")[0].get_node(civ_name).get_node("Cities").add_child(new_city)
	city_name_popup.show_city_popup(civ_name, new_city)
	queue_free()
