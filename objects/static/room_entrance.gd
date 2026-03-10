extends Node3D
class_name RoomEntrance

@export var door_id: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not OS.has_feature("editor_hint"):
		%EditorMesh.free()
