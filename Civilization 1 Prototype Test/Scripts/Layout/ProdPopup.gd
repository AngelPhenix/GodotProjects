extends CanvasLayer

onready var city_interface: Node = get_tree().get_nodes_in_group("city_interface")[0]

var city

func _ready() -> void:
	if GlobalData.units_data.has(city.current_production_name):
		$PanelContainer/VBoxContainer/HBoxContainer/Rebuild.visible = true
		$PanelContainer/VBoxContainer/HBoxContainer/Change.visible = true
	else:
		$PanelContainer/VBoxContainer/HBoxContainer/Change.text = "Confirm"
		$PanelContainer/VBoxContainer/HBoxContainer/Change.visible = true

func change_message(city_name: String, prod_finished: String) -> void:
	$PanelContainer/VBoxContainer/Label.text = city_name + " finished building a " + prod_finished

func _on_Change_pressed() -> void:
	city_interface.open(city)
	queue_free()

func _on_Rebuild_pressed() -> void:
	queue_free()
