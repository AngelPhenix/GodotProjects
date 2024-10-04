extends Control

var current_production: int = 2
var accumulated_production: int
var food: int = 1
var settler_needed_prod: int = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_queue() -> void:
	
	print("We're making a settler!")
