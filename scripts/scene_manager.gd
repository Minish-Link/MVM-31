extends Node

signal on_room_changed(_room_name: String, _entrance_id: int, _region: RoomData.Regions, _room_state: RoomData.RoomStates )
signal on_region_changed(new_region: RoomData.Regions)
signal on_room_state_changed(new_room_state: RoomData.RoomStates)

var temp_entrance_id: int = 0
var current_room_data: RoomData

#func load_next_room(room_path: String)
