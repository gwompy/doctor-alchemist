extends Node

signal cauldron_started(player_id, interactable_id, item, element)
signal cauldron_finished(player_id, interactable_id, item, element)
signal show_caul_inv()
signal hide_caul_inv()

@export var item_is_compatible : bool

var storage = 0
var output_item 
var stock_cauldron
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var output_item = $"../OutputItem"
	stock_cauldron = get_node("..").get_children(true)
	var players = get_tree().get_nodes_in_group("player_interaction")
	for node in players:
		node.connect("player_interacted", _on_player_interacted)
	$Timer.connect("timeout", _on_timer_timeout)

func _on_player_interacted(player_id, interactable_id, item, element):
	
	var interactable_is_correct = get_cauldron().interactable_id == interactable_id
	if storage < 1:
		item_is_compatible = item.processed == true and item.item_id != Globals.ItemID.POTION and element[0] != Globals.ElementalType.VOID
	if storage == 2:
		item_is_compatible = item.processed == true and item.item_id != Globals.ItemID.POTION
	
	#all input items are valid
	#var _cauldron_inputs = get_node("../InputItems").get_children() # For DEBUG purposes
	output_item = $"../OutputItem"
	if item.item_id != Globals.ItemID.NONE and interactable_is_correct and $Timer.is_stopped() and output_item.item_id == Globals.ItemID.NONE:
		if item_is_compatible and interactable_is_correct and $Timer.is_stopped() and storage < 2:
		
			#item becomes child node of InputItems
			add_input_item(item)
			storage += 1
			item.item_id = Globals.ItemID.NONE
			$"../RichTextLabel".text = "1/2"
			emit_signal("show_caul_inv")
			var elements = [6,6]
			emit_signal("cauldron_started", player_id, interactable_id, item.duplicate(), elements)
			
		if item_is_compatible and interactable_is_correct and $Timer.is_stopped() and storage == 2:
			
			
			#update stats
			if player_id == 0:
				Globals.potions0 += 1
				Globals.Tpotions0 += 1
			elif player_id == 1:
				Globals.potions1 += 1
				Globals.Tpotions1 += 1
			else:
				print("I recieved ", player_id , "As a player id. This should be 1 or 0.")
			
			
			
			
			#item becomes child node of InputItems
			add_input_item(item)
			storage = 0
			emit_signal("hide_caul_inv")
			#var elements = [6,6]
			#item.item_id = Globals.ItemID.NONE
			#emit_signal("cauldron_started", player_id, interactable_id, item.duplicate(), elements)
			$"../RichTextLabel".text = ""
			$"../CPUParticles2D".emitting = true
			var color_ramp = $"../CPUParticles2D".color_initial_ramp
			var count = 0
			for i in 2:
				var node
				if i == 0:
					node = get_node("../InputItems/Item1")
				if i == 1:
					node = get_node("../InputItems/Item3")
				match node.element[0]:
					Globals.ElementalType.FIRE:
						color_ramp.set_color(i, Color.RED)
					Globals.ElementalType.WATER:
						color_ramp.set_color(i, Color.BLUE)
					Globals.ElementalType.ELECTRIC:
						color_ramp.set_color(i, Color.YELLOW)
					Globals.ElementalType.WIND:
						color_ramp.set_color(i, Color.WHITE)
					Globals.ElementalType.EARTH:
						color_ramp.set_color(i, Color.GREEN)
					Globals.ElementalType.VOID:
						color_ramp.set_color(i, Color.REBECCA_PURPLE)
						

		#	match get_node("../InputItems/Item3").element[0]:
			#	Globals.ElementalType.FIRE:
			#		color_ramp.set_color(1, Color.RED)
			#	Globals.ElementalType.WATER:
			#		color_ramp.set_color(1, Color.BLUE)
			#	Globals.ElementalType.ELECTRIC:
			#		color_ramp.set_color(1, Color.YELLOW)
			#	Globals.ElementalType.WIND:
			#		color_ramp.set_color(1, Color.WHITE)
			#	Globals.ElementalType.EARTH:
			#		color_ramp.set_color(1, Color.GREEN)
			$"../AudioStreamPlayer2D".play()
			$Timer.start()
		else: return
		if not item.processed: return
		if not output_is_some: pass
	if interactable_is_correct and $Timer.is_stopped() and output_item.item_id == Globals.ItemID.POTION: #and item.item.id == Globals.ItemID.NONE:
		item_is_compatible = item.item_id == Globals.ItemID.NONE
		if item_is_compatible:
			var old_item = get_node("../OutputItem")
			emit_signal("cauldron_finished", player_id, interactable_id, old_item.duplicate(), old_item.element)
			handle_item_change(old_item, item)
			output_item.visible = false
		
#Idk why this is here, dont think its too important but i am slightly scared to delete it!
	#elif $"../OutputItem".item_id == Globals.ItemID.POTION and $Timer.is_stopped() and storage == 0:
		#print("Player " + str(player_id) + " interacted with potion")
		#var player_item = get_node("Player1/HandHitbox/Item")
		#player_item.item_id = $"../OutputItem".item_id
		#$"../OutputItem".item_id = Globals.ItemID.NONE
	
func _on_timer_timeout():
	$"../AudioStreamPlayer2D".stop()
	$"../CPUParticles2D".emitting = false
	var output_item = get_node("../OutputItem")
	var primary_type = get_node("../InputItems/Item1").element[0]
	var secondary_type = get_node("../InputItems/Item3").element[0]
	output_item.item_id = Globals.ItemID.POTION
	output_item.set_elemental_type(primary_type, secondary_type)
	output_item.visible = true


	var first_item = get_node("../InputItems/Item1")
	get_node("../InputItems").remove_child(first_item)
	first_item.queue_free()
	
	var second_item = get_node("../InputItems/Item3")
	get_node("../InputItems").remove_child(second_item)
	second_item.queue_free()
	
func handle_item_change(old_item: Item, new_item: Item):
		var index = old_item.get_index()
		#get_cauldron().remove_child(old_item)
		#old_item.queue_free()
		
		# set-up new item
		new_item.name = "OutputItem"
		get_cauldron().add_child(new_item)
		get_cauldron().move_child(new_item, index)
	#	if new_item.item_id == Globals.ItemID.NONE:
			#new_item.visible = false
		output_item.item_id = Globals.ItemID.NONE
		output_item.update_item_icon()

func output_is_some(node_path: String) -> bool:
	var node : Item = get_node(node_path)
	if node.element == [Globals.ElementalType.VOID]:
		return false
	else:
		return true

func add_input_item(item: Item):
	var index = 0
	item.name = "Item" + str(get_node("../InputItems").get_child_count() + 1)
	get_node("../InputItems").add_child(item)
	get_node("../InputItems").move_child(item, index)
	
func get_cauldron():
	var grinder = get_parent()
	if is_instance_valid(grinder):
		return grinder
	else:
		printerr("GrinderLogic doesn't have a valid parent node")
		return null
		
