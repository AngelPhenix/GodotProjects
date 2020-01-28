extends Node2D

const SCN_PARTICLE: PackedScene = preload("res://Scenes/Particle.tscn")
const SCN_BUBBLE: PackedScene = preload("res://Scenes/Bubble.tscn")

var score: int = 0
var monitored: int = 0
var steps: int = 0

func create_bubble() -> void:
	var bubble: Node = SCN_BUBBLE.instance()
	bubble.position = Vector2(rand_range(45, get_viewport_rect().size.x-45), rand_range(115/4, get_viewport_rect().size.y-115/4))
	add_child(bubble)

func popped(bubble_popped: Area2D) -> void:
	score += 2
	($Score as Label).text = "Score : " + str(score)
	($Bubble_pop as AudioStreamPlayer2D).play()
	var particle: Node = SCN_PARTICLE.instance()
	particle.global_position = bubble_popped.global_position
	add_child(particle)

func missed() -> void:
	score -= 1
	$Score.text = "Score : " + str(score)

func _on_Timer_timeout() -> void:
	($Timer as Timer).wait_time = rand_range(0.2, 1.5)
	create_bubble()