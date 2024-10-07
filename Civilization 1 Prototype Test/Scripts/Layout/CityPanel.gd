extends CanvasLayer

onready var prod_list = get_tree().get_nodes_in_group("production_list")[0]
onready var prod_btn: PackedScene = preload("res://Scenes/Layout/CityProdBtn.tscn")

var city
var built_buildings

func open(city_info: Dictionary) -> void:
	city = city_info["id"]
	built_buildings = city_info["built_buildings"]
	$NamePanel/Name.text = city_info["city_name"]
	$UnitPanel/Name.text = "Production : " + city_info["unit_in_production"]
	visible = true


func _on_Change_pressed():
	if $ProdContainer.visible == false: 
		# Builds the list of possible things to build by the city
		var available_production = []
		for unit_name in GlobalData.units_data.keys():
			if GlobalData.is_unit_unlocked(unit_name):
				available_production.append(unit_name)
		for building_name in GlobalData.buildings_data.keys():
			if GlobalData.is_building_unlocked(building_name):
				available_production.append(building_name)
		
		# Takes the already built list of possible things to build to erase buildings already built
		# So it's not possible to be built a second time
		var to_remove = []
		for production in available_production:
			if built_buildings.has(production):
				to_remove.append(production)
		for item in to_remove:
			available_production.erase(item)
			
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

func reset_panels() -> void:
	visible = false
	$ProdContainer.visible = false

func _on_Exit_pressed():
	reset_panels()
