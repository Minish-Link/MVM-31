extends Node
class_name RoomData

enum RoomStates {
	Default,
	Respite,
	Battle,
	Dialogue,
	Boss,
	Rescue
}

enum Regions {
	Starting,
	Factory,
	Jungle,
	Penultimate,
	Final
}

@export var region := Regions.Starting
@export var initial_room_state := RoomStates.Default
var current_room_state := RoomStates.Default

func _on_room_load() -> void:
	current_room_state = initial_room_state
	WorldData.on_region_changed.emit(region)
	WorldData.on_room_state_changed.emit(current_room_state)

func change_room_state(new_state: RoomStates):
	if new_state != current_room_state:
		current_room_state = new_state
		WorldData.on_room_state_changed.emit(current_room_state)
