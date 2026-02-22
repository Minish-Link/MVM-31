extends Node

var visited_rooms: Array[String]
var last_bench_room: String
var money: int
var collected_items: Dictionary[String, int]

signal on_room_changed(_room_name: String, _entrance_id: int, _region: RoomData.Regions, _room_state: RoomData.RoomStates )
signal on_region_changed(new_region: RoomData.Regions)
signal on_room_state_changed(new_room_state: RoomData.RoomStates)

## Returns true if room has never been visited before
func visit_new_room(room_name: String) -> bool:
	if room_name not in visited_rooms:
		visited_rooms.append(room_name)
		return true
	return false

func set_bench_room(room_name: String) -> void:
	last_bench_room = room_name

func get_money(amount: int) -> void:
	money += amount

## Returns false if the player does not have enough money to spend.
func spend_money(cost: int) -> bool:
	if money < cost:
		return false
	money -= cost
	return true

func has_item(item_name: String) -> bool:
	if item_name.to_lower() not in collected_items.keys():
		return false
	return collected_items[item_name.to_lower()] > 0

func get_item_count(item_name: String) -> int:
	if item_name.to_lower() not in collected_items.keys():
		return 0
	return collected_items[item_name.to_lower()]

func collect_item(item_name: String, amount: int = 1) -> void:
	if item_name.to_lower() not in collected_items.keys():
		collected_items[item_name.to_lower()] = 0
	collected_items[item_name.to_lower()] += amount

## TODO
func load_world_data_from_save() -> void:
	pass
