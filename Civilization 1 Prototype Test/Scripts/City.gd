extends Node2D

onready var world = get_tree().get_nodes_in_group("world")[0]

var civ_color: Color
var civ_name: String

var current_production: int = 2
var accumulated_production: int
var food: int = 1
var needed_prod: int = 6

#signal unit_produced(production_name)

func _ready() -> void:
	modulate = civ_color

#func change_queue() -> void:
#	print("We're making a settler!")

func process_queue() -> void:
	accumulated_production += current_production
	print("The City is processing !")
	print("Current production in city :" + str(accumulated_production))
	if accumulated_production >= needed_prod:
#		emit_signal("unit_produced", "Settler")
		print("New unit made ! A Settler appeared !")
		var new_unit = load("res://Scenes/Units/" + "Explorer" + ".tscn").instance()
		new_unit.position = position
		new_unit.civ_name = civ_name
		new_unit.civ_color = civ_color
		world.get_node(civ_name).get_node("Units").add_child(new_unit)
		accumulated_production = 0
