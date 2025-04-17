extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/GameOverMenu/TextureRect/Right-CenterCont/P2Info").text = """
	In total:
	• Player 2 cured {0} slimes
	• Player 2 made {1} potions
	""".format([Globals.Tslimes1,Globals.Tpotions1])
