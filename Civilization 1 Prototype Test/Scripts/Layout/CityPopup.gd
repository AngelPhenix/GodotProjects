extends CanvasLayer

onready var world = get_tree().get_nodes_in_group("world")[0]
onready var edit = get_tree().get_nodes_in_group("newcityname")[0]

var city_id
var player_civ

# A LA PLACE DE LE SHOW EN DUR
# Appeler une fonction qui va "reset" le text pour y mettre le nom de la liste prédéfinie
# Puis le passer en visible = true
func show_city_popup(civ_name: String, city: Node) -> void:
	player_civ = civ_name
	city_id = city
	if _names_still_available():
		var next_name_in_list: String = GlobalData.cities_name[civ_name][0]
		edit.text = next_name_in_list
	else:
		edit.text = "New name"
	visible = true

func _on_Button_pressed() -> void:
	if _names_still_available():
		if $PanelContainer/VBoxContainer/Name.text == GlobalData.cities_name[player_civ][0]:
			GlobalData.cities_name[player_civ].pop_front()
	world.confirm_city_name($PanelContainer/VBoxContainer/Name.text, city_id)
	get_tree().paused = false

func _names_still_available() -> bool:
	return GlobalData.cities_name[player_civ].size() > 0
