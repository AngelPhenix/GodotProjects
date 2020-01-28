extends Node

export (String, FILE, "*.json") var weapon_file_path : String

func load_weapons(file_path: String) -> Dictionary:
	var file = File.new()
	assert file.file_exists(file_path)
	file.open(file_path, file.READ)
	var weapons = parse_json(file.get_as_text())
	assert weapons.size() > 0 
	return weapons