@tool
extends Node3D
class_name RoomExit

## Drag and drop the Scene for the room to be loaded here.
## This will set the Leads to Path variable to the room's resource path.
## This variable remaining empty afterwards is intended behaviour.
@export var drag_next_room_here: PackedScene:
	set(_scene):
		if drag_next_room_here:
			leads_to_path = _scene.resource_path
			
@export var leads_to_path: String

@export var door_id: int = 0



# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	leads_to_path = leads_to.resource_path


func _on_body_entered(body: Node3D) -> void:
	if OS.has_feature("editor_hint"):
		return
	if body is Player:
		# TODO replace this with a more smooth transition between scenes
		SceneManager.stored_entrance_id = door_id
		SceneManager.start_load_room_from_path_string(leads_to_path)
