extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Globals has 1 less value because we change the day before it is called.
	get_node("/root/GameOverMenu/TextureRect/ReportTitle").text = "Game Over"
