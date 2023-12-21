extends Node2D

export var initial_number_of_buildings: int = 5
const SCN_BUILDING: PackedScene = preload("res://Scenes/Building.tscn")
const MIN_HOLE_WIDTH: int = 150
const MAX_HOLE_WIDTH: int = 300
const MIN_BUILDING_WIDTH: int = 250 #250 = valeur initiale
const MAX_BUILDING_WIDTH: int = 1500 #500 = valeur initiale
const MIN_BUILDING_HEIGHT: int = 200
const MAX_BUILDING_HEIGHT: int = 450


# Randomizing the seed to have different levels after each retry
# Generating X buildings after the initial one
# Connecting "player_is_dead" signal from the Player node to execute the _game_over method
func _ready() -> void:
	randomize()
	for _i in range(initial_number_of_buildings):
		algo()


# Moves all the buildings to the left at player speed
func _process(_delta: float) -> void:
	$Camera.position.x = $Player.position.x + 600


# Get all buildings in game to focus on the last one generated
# Instanciating a new building with width and height slightly different from the last one with min-max values
# If method called by _ready : add_child. Else it should use a chall_deferred to avoid warnings when game is closed
func algo() -> void:
	var buildings: Array = $Buildings.get_children()
	var last_position: Vector2 = buildings[buildings.size() - 1].position
	var building: Node = SCN_BUILDING.instance()
	var random_size = Vector2(rand_range(MIN_BUILDING_WIDTH, MAX_BUILDING_WIDTH), rand_range(MIN_BUILDING_HEIGHT, MAX_BUILDING_HEIGHT))
	var size: Vector2 = building.get_node("sprite").texture.get_size()
	building.scale = random_size / size
	var new_x_position: float = last_position.x + buildings[buildings.size() - 1].scale.x * (buildings[buildings.size() - 1].get_node("sprite").texture.get_size().x/2)
	var hole: float = rand_range(MIN_HOLE_WIDTH, MAX_HOLE_WIDTH)
	building.position = Vector2(new_x_position + hole + random_size.x / 2, get_viewport_rect().size.y - random_size.y/2 + 50)
	
	if buildings.size() < initial_number_of_buildings:
		$Buildings.add_child(building)
	else:
		$Buildings.call_deferred("add_child", building)
	buildings.append(building)
