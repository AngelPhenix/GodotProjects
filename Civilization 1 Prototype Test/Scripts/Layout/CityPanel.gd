extends CanvasLayer

onready var prod_list = get_tree().get_nodes_in_group("production_list")[0]

func open(city_info: Dictionary) -> void:
	$NamePanel/Name.text = city_info["city_name"]
	$UnitPanel/Name.text = "Production : " + city_info["unit_in_production"]
#	city_info["id"].current_production_name = "Archer"
	visible = true

func _on_Exit_pressed():
	visible = false


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
		var new_option: Button = Button.new()
		new_option.text = prod_name
		pass
