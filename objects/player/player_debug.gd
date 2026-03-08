extends Node3D
class_name DebugStuff

var command_line: LineEdit
@export var scen: PackedScene

var functions := {
	"help": _print_help,
	"give": _give_item,
	"reset": _reset_level_command,
	"noclip": _toggle_noclip,
	"load_level": _load_level,
}

func _ready() -> void:
	if not OS.has_feature("debug"):
		free()
	else:
		visible = true
		command_line = get_node("CommandLine")

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
	
func _on_command_line_editing_toggled(toggled_on: bool) -> void:
	PlayerCharacter.accepting_player_inputs = not toggled_on

# ----------------------------------------------------------------------
# Any function called by the command line should take a String argument,
# even if the argument is unused
# ----------------------------------------------------------------------

func _print_help(_args: String = "") -> void:
	print("available commands are: ")
	for func_name in functions.keys():
		print(func_name)

func _reset_level_command(_args: String = "") -> void:
	print("Reset Level Command Activated")
	print(get_tree().current_scene)
	print("Reload Outpint: %s" %get_tree().reload_current_scene())
	PlayerCharacter.position = Vector3(0,0,0)
	
func _give_item(arg: String = "") -> void:
	if arg == "":
		print("give command requires an argument")
		return
	print("giving %s to the player" % arg)
	WorldData.collect_item(arg)

func _toggle_noclip(_args: String = "") -> void:
	PlayerCharacter.noclip_enabled = not PlayerCharacter.noclip_enabled

func _load_level(arg: String = "") -> void:
	SceneManager.stored_entrance_id = 0
	SceneManager.start_load_room_from_path_string("res://levels/%s.tscn" % arg)
