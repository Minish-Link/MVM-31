extends Node3D
class_name DebugStuff

var command_line: LineEdit

var functions := {
	"give": _give_item,
	"reset": _reset_level_command,
	"help": _print_help,
	"noclip": _toggle_noclip
}

func _ready() -> void:
	if not OS.has_feature("debug"):
		free()
	else:
		visible = true
		command_line = get_node("CommandLine")

#func _physics_process(delta: float) -> void:
#	if (Input.is_key_pressed(KEY_F13) and Input.is_joy_button_pressed(0,JOY_BUTTON_BACK)) or (
#		(Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_R))):
#		_reset_level_command()

func _print_help(_args: String = "") -> void:
	print("available commands are: ")
	for func_name in functions.keys():
		print(func_name)

func _reset_level_command(_args: String = "") -> void:
	print("Reset Level Command Activated")
	print(get_tree().current_scene)
	print("Reload Outpint: %s" %get_tree().reload_current_scene())
	#get_tree().reload_current_scene()
	PlayerCharacter.position = Vector3(0,0,0)
	
func _give_item(arg: String = "") -> void:
	if arg == "":
		push_warning("give command requires an argument")
		return
	print("giving %s to the player" % arg)
	WorldData.collect_item(arg)
	#if (Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_I)):
	#	WorldData.collect_item("Slide")


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	var command := new_text.get_slice(" ", 0)
	if command not in functions.keys():
		print("%s is not a valid command. type help for a list of commands" % command)
		command_line.clear()
		return
	
	var arguments := ""
	var space_index := new_text.find(" ")
	if space_index > 0:
		arguments = new_text.substr(space_index + 1)
		
	functions[command].call(arguments)
	command_line.clear()

func _toggle_noclip(_args: String) -> void:
	PlayerCharacter.noclip_enabled = not PlayerCharacter.noclip_enabled

func _on_command_line_editing_toggled(toggled_on: bool) -> void:
	PlayerCharacter.accepting_player_inputs = not toggled_on
