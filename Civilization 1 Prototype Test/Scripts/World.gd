extends Node

var unit: PackedScene = preload("res://Scenes/Unit.tscn")
var explorer_unit: PackedScene = preload("res://Scenes/Units/Explorer.tscn")
var settler_unit: PackedScene = preload("res://Scenes/Units/Settler.tscn")

# Number of civilization in the game
export (int) var civ_num: int
# Array containing each civilization with their nodes
var civs: Array
# Cells in the tileset used in $Map:  0 = Water / 1 = Ground
enum {WATER, GROUND}
# Index to change civilization !
var index: int = 0
# Index to keep track of the selected unit !
var unit_index: int = 0
# Currently playing civilization
var current_civ: Node
# Currently playing unit
var current_unit: Node

var playable_units: Array

# Civilization Dictionary
#var civilizations: Dictionary = {"France" : {"color" : Color(0.148788, 0.556367, 0.777344)},
#	"Aztec" : {"color" : Color(0.188235, 0.729412, 0.309804)},
#	"America" : {"color" : Color(0.776471, 0.396078, 0.592157)},
#	"Japan" : {"color" : Color(1,1,1)},
#	"Egypt" : {"color" : Color(0.807843, 0.745098, 0.078431)},
#	"Somalia" : {"color" : Color(0.721569, 0.12549, 0.686275)},
#	"Peru" : {"color" : Color(0.679688, 0.244263, 0.244263)}
#}

var civilizations: Dictionary = {"France" : {"color" : Color(0.148788, 0.556367, 0.777344)},
	"Italy" : {"color" : Color(0.188235, 0.729412, 0.309804)},
	"Germany" : {"color" : Color(0.776471, 0.396078, 0.592157)}
}

signal city_clicked(city_data)

func _ready() -> void:
	# Checking if there's enough civilization colors, if not : reduce the number to civilization.size()
	if civ_num > len(civilizations.keys()):
		civ_num = len(civilizations.keys())
	randomize()
	init_fow()
	init_civilizations(civ_num)
	start_turn()

# Initialize Fog Of War before anything else is done
# Cover the entire tilemap with it
func init_fow() -> void:
	var map_size = ($Map as TileMap).get_used_rect()
	var fog_tile_id = 0
	
	for x in range(map_size.position.x, map_size.position.x + map_size.size.x):
		for y in range(map_size.position.y, map_size.position.y + map_size.size.y):
			($FOW as TileMap).set_cell(x, y, fog_tile_id)

# For each civilization, initialize their nodes
# Civ01 / Cities / Units in which every building and units are going to be added
# Initialize each civilization with a single unit (settler) for it to build a city.
# Place the units randomly on the map, at correct coordinates so its in the center of a tile.
func init_civilizations(number_of_civs: int) -> void:
	var possible_civs: Array = civilizations.keys()
	for i in number_of_civs:
		var civ_node: Node = Node.new()
		var choosen_civ: int = randi() % len(possible_civs)
		civ_node.name = possible_civs[choosen_civ]
		possible_civs.remove(choosen_civ)
		add_child(civ_node)
		civs.append(civ_node)
		
		var civ_cities: Node = Node.new()
		civ_cities.name = "Cities"
		civ_node.add_child(civ_cities)
		
		var civ_units: Node = Node.new()
		civ_units.name = "Units"
		civ_units.add_to_group("units")
		civ_node.add_child(civ_units)
	
#	for civ in civs:
#		var new_unit: Node = unit.instance()
##		var new_unit_two: Node = unit.instance()
#		var ground_cells: Array = ($Map as TileMap).get_used_cells_by_id(GROUND)
#		var values: Dictionary = civilizations.get(civ.name)
#		new_unit.modulate = values["color"]
##		new_unit_two.modulate = values["color"]
#		new_unit.position = ($Map as TileMap).map_to_world(ground_cells[randi() % len(ground_cells)]) + Vector2(16, 16)
##		new_unit_two.position = ($Map as TileMap).map_to_world(ground_cells[randi() % len(ground_cells)]) + Vector2(16, 16)
#		civ.get_node("Units").add_child(new_unit)
##		civ.get_node("Units").add_child(new_unit_two)

	for civ in civs:
		var new_explo: Node = explorer_unit.instance()
		var new_settler: Node = settler_unit.instance()
		var new_explo_two: Node = explorer_unit.instance()
		var ground_cells: Array = ($Map as TileMap).get_used_cells_by_id(GROUND)
		var values: Dictionary = civilizations.get(civ.name)
		
		new_explo.civ_name = civ.name
		new_explo.civ_color = values["color"]
		new_explo.attack = GlobalData.units_data["Explorer"]["attack"]
		new_explo.hp = GlobalData.units_data["Explorer"]["hp"]
		new_explo.total_movements = GlobalData.units_data["Explorer"]["moves"]
		
		new_explo_two.civ_name = civ.name
		new_explo_two.civ_color = values["color"]
		new_explo_two.attack = GlobalData.units_data["Explorer"]["attack"]
		new_explo_two.hp = GlobalData.units_data["Explorer"]["hp"]
		new_explo_two.total_movements = GlobalData.units_data["Explorer"]["moves"]
		
		
		new_settler.civ_name = civ.name
		new_settler.civ_color = values["color"]
		new_settler.attack = GlobalData.units_data["Settler"]["attack"]
		new_settler.hp = GlobalData.units_data["Settler"]["hp"]
		new_settler.total_movements = GlobalData.units_data["Settler"]["moves"]
		
		new_explo.position = ($Map as TileMap).map_to_world(ground_cells[randi() % len(ground_cells)]) + Vector2(16, 16)
		new_explo_two.position = ($Map as TileMap).map_to_world(ground_cells[randi() % len(ground_cells)]) + Vector2(16, 16)
		new_settler.position = ($Map as TileMap).map_to_world(ground_cells[randi() % len(ground_cells)]) + Vector2(16, 16)
		civ.get_node("Units").add_child(new_settler)
		civ.get_node("Units").add_child(new_explo)
		civ.get_node("Units").add_child(new_explo_two)
	

func start_turn() -> void:
	index = 0
	current_civ = civs[index]
	process_cities()
	reset_units()
	get_next_unit(current_civ)

func get_next_unit(civ: Node) -> void:
	for unit in current_civ.get_node("Units").get_children():
		if unit.state == unit.unit_state.WAITING:
			unit.state = unit.unit_state.PLAYING
			unit_index = playable_units.find(unit)
			print(unit_index)
			$Camera.position = unit.global_position
			return
	if index + 1 < len(civs):
		index += 1
		current_civ = civs[index]
		get_next_unit(current_civ)
	else:
		start_turn()

func loop_through_units() -> void:
	if playable_units.size() > 0:
		for unit in playable_units:
			unit.change_state(unit.unit_state.WAITING)

		if unit_index >= playable_units.size() - 1:
			unit_index = 0
		else:
			unit_index +=1

		var new_selected_unit: Node = playable_units[unit_index]
		new_selected_unit.change_state(new_selected_unit.unit_state.PLAYING)
		$Camera.position = new_selected_unit.global_position

func erase_from_playable_units(unit_entity: Node) -> void:
	
	pass
	
func reset_units() -> void:
	for node in get_tree().get_nodes_in_group("units"):
		for unit in node.get_children():
			unit.state = unit.unit_state.WAITING
			unit.movements_left = unit.total_movements
			playable_units.append(unit)

func process_cities() -> void:
	for city in get_tree().get_nodes_in_group('city'):
		if city.has_method('process_queue'):
			city.process_queue()
