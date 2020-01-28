extends "res://Scripts/const_enemy.gd"

const bullet = preload("res://Scenes/Enemy_bullet.tscn")

var angle = 0.0

func _ready():
	life = 25
	speed = 50
	resist = 3
	strength = 2 

func _physics_process(delta):
	angle += 0.05
	pos_clock(angle)
	if angle > 360:
		angle = 0.0
	
	if get_parent().has_node("Player"):
		var player = get_parent().get_node("Player")
		var direction = (player.position - position).normalized()
		var motion = direction * speed * delta
		position += motion
		look_at(player.position)

func pos_clock(value):
	$shape.position.x = 50 * sin(value)
	$shape.position.y = 50 * cos(value)

func _on_Timer_timeout():
	randomize()
	var bul = bullet.instance()
	get_parent().add_child(bul)
	var line = $shape/Sprite.global_position - $sprite.global_position
	var line_angle = line.angle()
	bul.start($shape/Sprite.global_position, line_angle)
	$Timer.wait_time = rand_range(0.2,0.5)
	$Timer.start()