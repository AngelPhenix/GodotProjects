extends CanvasLayer

onready var world = get_tree().get_nodes_in_group("world")[0]

var city_id

func _on_Button_pressed():
	world.confirm_city_name($PanelContainer/VBoxContainer/Name.text, city_id)
	get_tree().paused = false
