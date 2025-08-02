extends Node

var bestscore = 0: set = set_bestscore
const filepath = "res://saves/bestscore.data"

# Calls load_bestscore method
func _ready():
	load_bestscore()

# If file exists, opens and get bestcore out of it
func load_bestscore():
	if !FileAccess.file_exists(filepath):
		return
	
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file:
		bestscore = file.get_var()
		file.close()

# Saves bestscore inside file in filepath
func save_bestscore():
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	if file:
		file.store_var(bestscore)
		file.close()

# Setter when bestscore is changed in another scene
func set_bestscore(new_value):
	bestscore = new_value
	save_bestscore()
