extends StaticBody2D

signal creating_tile()


# Method called whenever a playerprojectile hits this scene
# Sends a signal to the World for it to create a tile right below the wall
func create_tile_on_destroy() -> void:
	emit_signal("creating_tile", position)
	queue_free()
