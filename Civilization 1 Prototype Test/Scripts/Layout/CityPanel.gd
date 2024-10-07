extends CanvasLayer

onready var prod_list = get_tree().get_nodes_in_group("production_list")[0]
onready var prod_btn: PackedScene = preload("res://Scenes/Layout/CityProdBtn.tscn")

var city

func open(city_info: Dictionary) -> void:
	city = city_info["id"]
	$NamePanel/Name.text = city_info["city_name"]
	$UnitPanel/Name.text = "Production : " + city_info["unit_in_production"]
	visible = true

func _on_Exit_pressed():
	visible = false
	for node in prod_list.get_children():
		node.queue_free()


func _on_Change_pressed():
	# OPEN PANEL TO CHANGE PRODUCTION UNIT OF THE CITY SELECTED
	var available_production = []
	
	for unit_name in GlobalData.units_data.keys():
		if GlobalData.is_unit_unlocked(unit_name):
			available_production.append(unit_name)
	for building_name in GlobalData.buildings_data.keys():
		if GlobalData.is_building_unlocked(building_name):
			available_production.append(building_name)
	
	display_available_production(available_production)

func display_available_production(available_prod: Array):
	for prod_name in available_prod:
		var new_option: Button = prod_btn.instance()
		new_option.prod_name = prod_name
		new_option.city = city
		prod_list.add_child(new_option)
	
	$ProdContainer.visible = true

func production_changed(new_prod_name: String) -> void:
	$UnitPanel/Name.text = "Production : " + new_prod_name
