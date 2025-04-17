extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/GameOverMenu/TextureRect/Bottom-CenterCont/RestartButton").text = "Restart"


#runs when button is clicked
func _on_pressed():
	
	#allows the day to change
	Globals.day_incremented = false
	
	#resets the statistics
	Globals.potions0 = 0
	Globals.potions1 = 0
	Globals.slimes0 = 0
	Globals.slimes1 = 0

	
	#Resets totals
	Globals.Tpotions0 = 0
	Globals.Tpotions1 = 0
	Globals.Tslimes0 = 0
	Globals.Tslimes1 = 0


	#restart the day count
	Globals.day = 1
	
	#returns to the title screen
	TransitionScreen.transition("res://scenes/title_screen.tscn")
