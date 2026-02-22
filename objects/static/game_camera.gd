extends Camera3D

func _ready() -> void:
	position.z = 10.0
	position.x = PlayerCharacter.position.x
	position.y = PlayerCharacter.position.y

var left_boundary := -10.0
var right_boundary := 10.0
var top_boundary := 10.0
var bottom_boundary := -10.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# TODO
	var camera_pos = Vector2(position.x, position.y)
	var player_pos = Vector2(PlayerCharacter.position.x, PlayerCharacter.position.y)
	var diff: Vector2 = player_pos - camera_pos
	position.x = move_toward(camera_pos.x, player_pos.x, pow(diff.x, 4) * delta)
	position.y = move_toward(camera_pos.y, player_pos.y, pow(diff.y, 4) * delta)
	position.x = min(max(position.x, left_boundary), right_boundary)
	position.y = min(max(position.y, bottom_boundary), top_boundary)
