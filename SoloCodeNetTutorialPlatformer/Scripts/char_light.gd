extends Node2D

export var light_color = Color(1,1,1,1)
export (float) var energy = 1.0
export (bool) var gresille = false

func _ready():
	$Light2D.color = light_color
	$Light2D.energy = energy
	$Sprite.visible = false

func _physics_process(delta):
	if gresille:
		randomize()
		var x = rand_range(0, 100)
		if x > 90:
			$Light2D.energy = energy + rand_range(-0.2, 0.2)