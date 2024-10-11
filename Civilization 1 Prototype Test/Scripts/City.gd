extends Node2D

onready var world = get_tree().get_nodes_in_group("world")[0]
onready var city_interface = get_tree().get_nodes_in_group("city_interface")[0]
onready var city_popup = get_tree().get_nodes_in_group("built_city_popup")[0]
onready var prod_popup = preload("res://Scenes/Layout/ProdPopup.tscn")

var civ_color: Color
var civ_name: String
var city_name: String
var current_production_name: String = "Settler"
var accumulated_production: int

var food: int = 1
var production: int = 2
var science: int = 1

var built_buildings: Array

func process_queue() -> void:
	accumulated_production += production
	if GlobalData.units_data.has(current_production_name):
		if accumulated_production >= GlobalData.units_data.get(current_production_name)["production"]:
			var new_unit = load("res://Scenes/Units/" + current_production_name + ".tscn").instance()
			new_unit.position = position
			new_unit.civ_name = civ_name
			new_unit.civ_color = civ_color
			new_unit.attack = GlobalData.units_data[current_production_name]["attack"]
			new_unit.hp = GlobalData.units_data[current_production_name]["hp"]
			new_unit.total_movements = GlobalData.units_data[current_production_name]["moves"]
			world.get_node(civ_name).get_node("Units").add_child(new_unit)
			
			_display_prod_finished(city_name, current_production_name)
			
			accumulated_production = 0
	if GlobalData.buildings_data.has(current_production_name):
		if accumulated_production >= GlobalData.buildings_data.get(current_production_name)["production"]:
			built_buildings.append(current_production_name)
			food += GlobalData.buildings_data.get(current_production_name)["food_bonus"]
			production += GlobalData.buildings_data.get(current_production_name)["production_bonus"]
			science += GlobalData.buildings_data.get(current_production_name)["science_bonus"]
			
			_display_prod_finished(city_name, current_production_name)
			current_production_name = "Settler"
			accumulated_production = 0

# WHEN THE CITY'S SPRITE IS CLICKED, OPEN THE WINDOW TO INTERACT WITH IT
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		get_tree().paused = true
		city_interface.open(self)

func _display_prod_finished(city_name: String, current_production_name: String) -> void:
	var popup: Node = prod_popup.instance()
	popup.city = self
	popup.change_message(city_name, current_production_name)
	add_child(popup)
