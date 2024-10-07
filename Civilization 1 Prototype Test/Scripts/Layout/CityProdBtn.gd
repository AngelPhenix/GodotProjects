extends Button

onready var city_interface = get_tree().get_nodes_in_group("city_interface")[0]

var prod_name: String
var city

func _ready() -> void:
	text = prod_name

func _on_Button_pressed():
	change_production_queue(prod_name)

func change_production_queue(production: String) -> void:
	city.current_production_name = production
	city_interface.production_changed(production)
	get_parent().visible = false
