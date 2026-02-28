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

@export var room_name: String = ""
@export var region := Regions.Starting
@export var initial_room_state := RoomStates.Default
var current_room_state := RoomStates.Default
var room_entrances: Dictionary[int, RoomEntrance]

func _ready() -> void:
	assert(room_name != "", "RoomData object needs a Room Name")
	for child in get_children():
		if child is RoomEntrance:
			assert(child.door_id not in room_entrances.keys(), "RoomData object has one or more Entrances with overlapping door ids")
			room_entrances[child.door_id] = child
		elif child is RoomExit:
			assert(child.leads_to_path, "%s needs an exit room in 'Leads To' assigned to it." % child.name)
	assert(room_entrances.size() > 0, "RoomData object needs at least one Entrance as a child node")
	var temp_id: int = SceneManager.stored_entrance_id
	assert(temp_id in room_entrances.keys(), "Door ID of %d not found among entrances on this RoomData object" % temp_id )
	
	PlayerCharacter.position = room_entrances[temp_id].position

func _on_room_load() -> void:
	current_room_state = initial_room_state
	SceneManager.on_region_changed.emit(region)
	SceneManager.on_room_state_changed.emit(current_room_state)
	SceneManager.on_room_changed.emit(
		room_name,
		SceneManager.temp_entrance_id,
		region,
		initial_room_state
		)

func change_room_state(new_state: RoomStates):
	if new_state != current_room_state:
		current_room_state = new_state
		SceneManager.on_room_state_changed.emit(current_room_state)
