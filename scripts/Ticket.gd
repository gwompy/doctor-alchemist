extends Node

var ticket_id: int

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var primary_type = rng.randi_range(0,4)
	var secondary_type = primary_type - 1
	if secondary_type < 0:
		secondary_type = 5
	
	$Potion.item_id = Globals.ItemID.POTION
	$Potion.set_elemental_type(primary_type, secondary_type)
	
	get_node("VBoxContainer/TypeOne").text = Globals.ElementalType.keys()[primary_type]
	get_node("VBoxContainer/TypeTwo").text = Globals.ElementalType.keys()[secondary_type]
