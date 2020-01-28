extends Node

func _ready() -> void:
	_connect_buttons_doors()

func _connect_buttons_doors() -> void:
	var button_door_nodes: Array = $ButtonsDoors.get_children()
	for button in button_door_nodes:
		if button is Area2D:
			var starting_index: int = button.name.find("_", 0)
			var button_number: String = button.name.substr(starting_index +1, button.name.length())
			for door in button_door_nodes:
				if door is StaticBody2D:
					var chest_to_connect: int = door.name.find(button_number, 0)
					if chest_to_connect != -1:
						button.connect("open_door", door, "_on_Button_open_door")
						print(str(button.name) + " connected to " + str(door.name) + "!")