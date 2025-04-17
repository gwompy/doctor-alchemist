extends Node

signal extractor_started(player_id, interactable_id, item)
signal extractor_finished(player_id, interactable_id, item)

var player : int
var interactable : int
@export var item_is_compatible : bool

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player_interaction")
	for node in players:
		node.connect("player_interacted", _on_player_interacted)
	$Timer.connect("timeout", _on_timer_timeout)
	
func _on_player_interacted(player_id: int, interactable_id: int, item: Item, element) -> void:
	# booleans to simplify if statements
	var interactable_is_correct = get_extractor().interactable_id == interactable_id
	var player_item_is_some = item.item_id != Globals.ItemID.NONE
	var item_is_none = get_node("../Item").item_id == Globals.ItemID.NONE
	var item_is_processed = get_node("../Item").processed
	item_is_compatible = item.item_id == Globals.ItemID.LIZARDS_TAIL \
						  || item.item_id == Globals.ItemID.GOLDEN_TOURMALINE \
						  || item.item_id == Globals.ItemID.MOLTEN_HEART \
						  || item.item_id == Globals.ItemID.STAR_SAPPHIRE \
						  || item.item_id == Globals.ItemID.SILENT_ROSE
	
	# don't take in already processed or no materials
	if item.processed: return
	# start the grinder if the timer is stopped and the grinder has no item
	if item_is_compatible and interactable_is_correct && $Timer.is_stopped() && item_is_none && player_item_is_some:
		emit_signal("extractor_started", player_id, interactable_id, get_node("../Item").duplicate(), get_node("../Item").element)
		$"../AudioStreamPlayer2D".play()
		$Timer.start()
		var old_item = get_node("../Item")
		handle_item_change(old_item, item)
	# finish the grinder if the timer has stopped and the item is processed
	elif $"../Item".item_id != Globals.ItemID.NONE:
		item_is_compatible = item.item_id == Globals.ItemID.NONE 
		if item.item_id == Globals.ItemID.NONE and interactable_is_correct && $Timer.is_stopped() && item_is_processed:
			var old_item = get_node("../Item")
			emit_signal("extractor_finished", player_id, interactable_id, old_item.duplicate(), old_item.element)
			handle_item_change(old_item, item)
	# in all other cases don't allow the player to interact
	else:
		return

func get_extractor() -> Area2D:
	var distillery = get_parent()
	if is_instance_valid(distillery):
		return distillery
	else:
		printerr("DistilleryLogic doesn't have a valid parent node")
		return null

func _on_timer_timeout() -> void:
	$"../AudioStreamPlayer2D".stop()
	var old_item = get_node("../Item")
	old_item.set_processed_status(true)
	
func handle_item_change(old_item: Item, new_item: Item):
		var index = old_item.get_index()
		get_extractor().remove_child(old_item)
		old_item.queue_free()
		
		# set-up new item
		new_item.name = "Item"
		get_extractor().add_child(new_item)
		get_extractor().move_child(new_item, index)
