extends Area2D

@export var velocity = Vector2(0, 200)

# Connects signal "area_entered" to "_on_area_enter" for script's children
func _ready():
	connect("area_entered", Callable(self, "_on_area_enter"))

# Moves the powerup
func _process(delta):
	translate(velocity*delta)

# If powerup gets out of screen, destroy it
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()