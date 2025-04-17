extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/DayOverMenu/TextureRect/Left-CenterCont/P1Info").text = """
	• Player 1 cured {0} slimes
	• Player 1 made {1} potions
	""".format([Globals.slimes0,Globals.potions0])
