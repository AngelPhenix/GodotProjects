extends Label

var velocity = Vector2(0,-0.03)

func _ready():
	$anim.play("fade_out")

func _process(_delta):
	position = position + velocity

func _on_anim_animation_finished(_anim_name):
	queue_free()
