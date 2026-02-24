extends Camera3D

var left_boundary := -10.0
var right_boundary := 10.0
var top_boundary := 10.0
var bottom_boundary := -10.0

var left_offset := 0.0
var right_offset := 0.0
var top_offset := 0.0
var bottom_offset := 0.0

func _ready() -> void:
	position.z = 8.0
	position.x = PlayerCharacter.position.x
	position.y = PlayerCharacter.position.y
	set_camera_boundaries()

func set_camera_boundaries() -> void:
	var screen_bottom_left = project_position(Vector2(0,get_viewport().get_visible_rect().size.y), position.z)
	var screen_top_right = project_position(Vector2(get_viewport().get_visible_rect().size.x, 0), position.z)
	left_offset = screen_bottom_left.x
	right_offset = screen_top_right.x
	top_offset = screen_top_right.y
	bottom_offset = screen_bottom_left.y
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var camera_pos = Vector2(position.x, position.y)
	var player_pos = Vector2(PlayerCharacter.position.x, PlayerCharacter.position.y)
	var diff: Vector2 = player_pos - camera_pos
	position.x = move_toward(camera_pos.x, player_pos.x, pow(diff.x, 4) * delta)
	position.y = move_toward(camera_pos.y, player_pos.y, pow(diff.y, 4) * delta)
	position.x = min(max(position.x, left_boundary - left_offset), right_boundary - right_offset)
	position.y = min(max(position.y, bottom_boundary - bottom_offset), top_boundary - top_offset)
