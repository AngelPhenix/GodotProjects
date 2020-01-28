extends Sprite

export var velocity = Vector2()

# Gets stars moving from top to bottom at velocity speed
# If disappear from screen, go back to top of the three stars sprite
func _process(delta):
	translate(velocity * delta)
	if get_position().y > get_viewport_rect().size.y:
		set_position(Vector2(0,-320))