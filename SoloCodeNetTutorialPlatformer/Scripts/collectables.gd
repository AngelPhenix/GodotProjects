extends Area2D

signal picked_up

var textures = {
	"x1" : 	"res://Sprites/platformer_sprites/Coins/X1.png",
	"x10" : "res://Sprites/platformer_sprites/Coins/X10.png",
	"hp" : "res://Sprites/platformer_sprites/Coins/HP.png",
	"mp" : "res://Sprites/platformer_sprites/Coins/MP.png"
}

var lights = {
	"x1" : "#ffea21",
	"x10" : "#4aff21",
	"hp" : "#ff3030",
	"mp" : "#fd30ff"
}

var text_name

func init(tile_name, pos):
	text_name = tile_name
	$sprite.texture = load(textures[text_name])
	$Light2D.color = Color(lights[text_name])
	position = pos

func _on_Coin_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("picked_up", text_name)
		$shape.set_deferred("disabled", true)
#		$shape.disabled = true
		$tween.interpolate_property(self, "position", position, Vector2(position.x, position.y - 50), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$tween.start()

func _on_tween_tween_completed(object, key):
	queue_free()
