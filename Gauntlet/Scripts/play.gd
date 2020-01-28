extends Label

onready var intro_song = get_tree().get_nodes_in_group("introsong")[0]
onready var tween = intro_song.get_node("tween")
onready var tint = intro_song.get_parent().get_node("tint")

func callback():
	tween.interpolate_property(intro_song, "volume_db", intro_song.volume_db, intro_song.volume_db - 30, 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(tint, "modulate:a", tint.modulate.a, tint.modulate.a + 1, 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed") 
	intro_song.stop()
	get_tree().change_scene("res://Stages/FinishedStages/Map01.tscn")