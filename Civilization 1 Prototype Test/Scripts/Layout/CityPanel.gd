extends CanvasLayer

func open(city_info: Dictionary) -> void:
	$NamePanel/Name.text = city_info["city_name"]
	$UnitPanel/Name.text = "Production : " + city_info["unit_in_production"]
#	city_info["id"].current_production_name = "Archer"
	visible = true

func _on_Exit_pressed():
	visible = false


func _on_Change_pressed():
	# OPEN PANEL TO CHANGE PRODUCTION UNIT OF THE CITY SELECTED
	pass # Replace with function body.
