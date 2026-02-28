extends Node

signal on_room_changed(_room_name: String, _entrance_id: int, _region: RoomData.Regions, _room_state: RoomData.RoomStates )
signal on_region_changed(new_region: RoomData.Regions)
signal on_room_state_changed(new_room_state: RoomData.RoomStates)

var stored_entrance_id: int = 0
var current_room_data: RoomData
var stored_next_room_path: String = ""
var stored_next_room_scene: PackedScene = null

var fade_timer: Timer
var fading_out := false
@export var fade_time := 0.3

func _ready() -> void:
	if not fade_timer:
		fade_timer = Timer.new()
		add_child(fade_timer)
		fade_timer.one_shot = true
		fade_timer.autostart = false
	set_process(true)
	start_room_fadein()

func start_room_fadein() -> void:
	fading_out = false
	fade_timer.start(fade_time)

func start_room_fadeout() -> void:
	%FadeBox.visible = true
	PlayerCharacter.prepare_for_room_transition()

func _process(_delta: float) -> void:
	if not fade_timer.is_stopped():
		if fading_out:
			(%FadeBox as ColorRect).color.a = 1.0 - (fade_timer.time_left / fade_time)
		else:
			(%FadeBox as ColorRect).color.a = fade_timer.time_left / fade_time
	else:
		if fading_out:
			%FadeBox.color.a = 1.0
		else:
			%FadeBox.visible = false
			%FadeBox.color.a = 0.0

func start_room_transition(exit_data: RoomExit) -> void:
	# TODO
	pass

func _load_room_from_scene(packed_scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(packed_scene)

func _load_room_from_path_string(room_path: String) -> void:
	get_tree().change_scene_to_file(room_path)

func start_load_room_from_scene(packed_scene: PackedScene) -> void:
	call_deferred("_load_room_from_scene", packed_scene)

func start_load_room_from_path_string(room_path: String) -> void:
	call_deferred("_load_room_from_path_string", room_path)
