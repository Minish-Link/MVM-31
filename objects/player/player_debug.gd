extends Node3D
class_name DebugStuff

func _ready() -> void:
	if not OS.has_feature("debug"):
		free()

func _physics_process(delta: float) -> void:
	_reset_level_command()
	_give_item()
	
func _reset_level_command():
	if (Input.is_key_pressed(KEY_F13) and Input.is_joy_button_pressed(0,JOY_BUTTON_BACK)) or (
		(Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_R))):
		print("Reset Level Command Activated")
		print(get_tree().current_scene)
		print("Reload Outpint: %s" %get_tree().reload_current_scene())
		get_tree().reload_current_scene()
		PlayerCharacter.position = Vector3(0,0,0)
	
func _give_item():
	if (Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_I)):
		WorldData.collect_item("Slide")
