extends Control

onready var tile_label: Label = $Tiles
onready var life_HUD: TextureProgress = $LifeHUD
onready var time_label: Label = $Time
onready var score_label: Label = $Score

var tile_number: int
var time_left: int = 180
var score: int


func _ready() -> void:
	time_label.text = "Time   " + str(time_left)


# Method used everytime the player lose or gets more life
# Signal sent by the "Player" scene, connected on the World node
func _life_changed(remaining_life: int) -> void:
	life_HUD.value = remaining_life


# Method used everytime a blue tile is stepped on
# Signal sent by the "FloorTile" scene, connected on the World node
func _on_converted_tile() -> void:
	tile_number -= 1
	score += 10
	score_label.text = "Score   " + str(score)
	tile_label.text = "Tiles to convert : " + str(tile_number)
	if tile_number <= 0:
		# Changement de scène
		print("Jeu terminé, level up !")


# Executed every seconds by the Timer child from the World Node
# Updates the UI and makes the player lose the game is time is 0
func _on_TimeLeft_timeout():
	self.time_left -= 1
	time_label.text = "Time   " + str(time_left)

	if time_left <= 0 :
		 print("lost !")
