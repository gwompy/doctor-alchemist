extends Node

signal plate_full(player_id, interactable_id, item)

var var_item
@export var item_is_compatible : bool

func _ready() -> void:
	var_item = get_node("../Item")
	var players = get_tree().get_nodes_in_group("player_interaction")
	for node in players:
		node.connect("player_interacted", _on_player_interacted)

func _on_player_interacted(player_id: int, interactable_id: int, item: Item, element) -> void:
	# save old item
	var old_item = get_node("../Item")
	item_is_compatible = item.item_id != Globals.ItemID.NONE
	# make sure the correct plate is being edited
	if item_is_compatible and get_plate().interactable_id == interactable_id:
		emit_signal("plate_full", player_id, interactable_id, old_item.duplicate(), old_item.element)
		
		# remove old item from node tree
		var index = old_item.get_index()
		get_plate().remove_child(old_item)
		old_item.queue_free()
		
		# set-up new item
		item.name = "Item"
		get_plate().add_child(item)
		get_plate().move_child(item, index)
		#item.element = var_element
		get_node("../Item").element = element
		get_node("../Item").update_item_icon()
	# cancel the process on all other plates
	else:
		return

func get_plate() -> Area2D:
	var plate = get_parent()
	if is_instance_valid(plate):
		return plate
	else:
		printerr("PlayerInteraction has no valid parent (Player node).")
		return null
