extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/GameOverMenu/TextureRect/Left-CenterCont/P1Info").text = """
	In total:
	• Player 1 cured {0} slimes
	• Player 1 made {1} potions
	""".format([Globals.Tslimes0,Globals.Tpotions0])
