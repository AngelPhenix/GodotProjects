extends PassiveUnit

onready var city_scn: PackedScene = preload("res://Scenes/City.tscn")

func _init() -> void:
	vision_radius = 1

func _ready() -> void:
	pass
#	defense = 0
#	total_movements = 2

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("build") and state == unit_state.PLAYING:
		build_city(position)

func build_city(settlers_position: Vector2) -> void:
	var new_city: Node = city_scn.instance()
	new_city.civ_color = civ_color
	new_city.civ_name = civ_name
	new_city.modulate = civ_color
	new_city.position = settlers_position
	get_tree().get_nodes_in_group("world")[0].get_node(civ_name).get_node("Cities").add_child(new_city)
	killed()
