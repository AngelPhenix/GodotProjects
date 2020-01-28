extends Node

var weapons: Dictionary = {}
var gun_scn: PackedScene = preload("res://Scenes/Gun.tscn")
var coin_scn: PackedScene = preload("res://Scenes/Coin.tscn")
onready var player = get_tree().get_nodes_in_group("player")[0]

export (String, FILE, "*.json") var weapon_file_path : String

func _ready() -> void:
	weapons = load_weapons(weapon_file_path)

# On return sous la forme de dictionnaire le fichier avec le JSON contenant les armes et leurs caractéristiques.
func load_weapons(file_path: String) -> Dictionary:
	var file = File.new()
	assert file.file_exists(file_path)
	file.open(file_path, file.READ)
	var weapons = parse_json(file.get_as_text())
	assert weapons.size() > 0 
	return weapons

# weapons contient le JSON entier. Dictionnaire de taille X armes. Contenant eux-mêmes chacun un dictionnaire
# avec les spécificités de chaque armes.
# Pour accéder aux weapons, on doit d'abord avoir leur nom, grâce à ".keys()" qui prends la clé et non les valeurs
# Puis, lorsque le nom de l'arme à été choisie, on attrape ses caractéristiques avec "Dic.get(nom_arme)"
func create_weapon(weapon_position: Vector2) -> void:
	if weapons.size() > 0:
		var all_weapons = weapons.keys()
		var weapon_key = all_weapons[int(rand_range(0, all_weapons.size()))]
		var new_created_weapon = gun_scn.instance()
		var texture = load(weapons[weapon_key]["png_path"])
		new_created_weapon.get_node("sprite").texture = texture
		new_created_weapon.position = weapon_position
		new_created_weapon.weapon_informations[weapon_key] = weapons.get(weapon_key)
		call_deferred("add_child", new_created_weapon)
		weapons.erase(weapon_key)
	else:
		var created_coin = coin_scn.instance()
		created_coin.position = player.position
		call_deferred("add_child", created_coin)
		player.get_node("audio/treasure").play()

func initialize_weapon_player() -> void:
	var weapon_key = weapons.keys()[0]
	player.equipped_weapon[weapon_key] = weapons.get(weapon_key)
	player.weapons[weapon_key] = weapons.get(weapon_key)
	weapons.erase(weapon_key)