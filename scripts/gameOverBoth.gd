extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#stats for both players are added for this label.
	get_node("/root/GameOverMenu/TextureRect/CenterCont/BothInfo").text = """
	In total:
	• You both cured {0} slimes
	• You both made {1} potions
	""".format([(Globals.Tslimes1+Globals.Tslimes0),(Globals.Tpotions1+Globals.Tpotions0)])
