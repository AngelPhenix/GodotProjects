extends Node2D

onready var world = get_tree().get_nodes_in_group("world")[0]
onready var city_interface = get_tree().get_nodes_in_group("city_interface")[0]

var civ_color: Color
var civ_name: String
var current_production: int = 2
var current_production_name: String = "Settler"
var accumulated_production: int
var food: int = 1
var needed_prod: int = 6

func _ready() -> void:
	modulate = civ_color

#func change_queue() -> void:
#	print("We're making a settler!")

func process_queue() -> void:
	accumulated_production += current_production
	if accumulated_production >= needed_prod:
		var new_unit = load("res://Scenes/Units/" + current_production_name + ".tscn").instance()
		new_unit.position = position
		new_unit.civ_name = civ_name
		new_unit.civ_color = civ_color
		world.get_node(civ_name).get_node("Units").add_child(new_unit)
		accumulated_production = 0

# WHEN THE CITY'S SPRITE IS CLICKED, OPEN THE WINDOW TO INTERACT WITH IT
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		city_interface.open({
			"id" : self,
			"city_name" : "Paris", 
			"unit_in_production" : current_production_name,
		})
