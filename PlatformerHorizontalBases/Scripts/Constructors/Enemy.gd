extends KinematicBody2D
class_name EnemyController

var health: int
var move_speed: int
var direction: int
var velocity: Vector2 = Vector2()
var weight: float = 1
var gravity: int = 30
var const_speed: Vector2 = Vector2(200, 70)

var flash: Shader = preload("res://Shaders/flash.shader")
onready var player = get_tree().get_nodes_in_group("player")[0]

func _ready() -> void:
	add_to_group("enemy")

func hit(damage: int, weapon_weight: int) -> void:
	health -= damage
	if health > 0:
		knockback(weapon_weight)
		flash(Color(1,0,0,1), 0.08)
	else:
		death()

func flash(color: Color, time: float) -> void:
	var shader_material = ShaderMaterial.new()
	$sprite.set_material(shader_material)
	shader_material.set_shader_param("color", color)
	shader_material.set_shader(flash)
	yield(get_tree().create_timer(time), "timeout")
	$sprite.material.shader = null

func knockback(wp_weight: float) -> void:
	var dir = sign(global_position.x - player.global_position.x)
	var resistance: float = weight / wp_weight
	velocity.x += dir * (const_speed.x / resistance)
	velocity.y = -(const_speed.y / resistance)
	velocity = move_and_slide(velocity, Vector2(0,-1))

func death() -> void:
	queue_free()