extends Node

var bestscore = 0 setget set_bestscore
const filepath = "res://saves/bestscore.data"

# Calls load_bestscore method
func _ready():
	load_bestscore()

# If file exists, opens and get bestcore out of it
func load_bestscore():
	var file = File.new()
	if !file.file_exists(filepath):
		return
	file.open(filepath, File.READ)
	bestscore = file.get_var()
	file.close()

# Saves bestscore inside file in filepath
func save_bestscore():
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_var(bestscore)
	file.close()

# Setter when bestscore is changed in another scene
func set_bestscore(new_value):
	bestscore = new_value
	save_bestscore()