extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/DayOverMenu/TextureRect/Right-CenterCont/P2Info").text = """
	• Player 2 cured {0} slimes
	• Player 2 made {1} potions
	""".format([Globals.slimes1,Globals.potions1])
