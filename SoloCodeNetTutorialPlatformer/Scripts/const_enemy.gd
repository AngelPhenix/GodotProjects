extends KinematicBody2D

var explosion = preload("res://Scenes/Explode.tscn")
var label = preload("res://Scenes/Damage.tscn")

var velocity = Vector2()
var speed = 100
var direction = 1
var life = 10

var resist = 1
var strength = 1

const GRAVITY = 1000

func init(pos):
	position = pos

func _ready():
	randomize()

func hit(damage_taken):
	damage_taken = damage_taken/resist
	life -= damage_taken
	var damage_label = label.instance()
	damage_label.init(position, damage_taken)
	get_parent().add_child(damage_label)
	
	if life <= 0:
		var explo = explosion.instance()
		explo.init(position)
		get_parent().add_child(explo)
		queue_free()