extends Node
class_name StateMachine

@export var initial_state: State
var current_state: State
var states: Dictionary = {}

# Must be called by the parent node when ready
func sm_init(parent: CharacterBody3D) -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			child.parent = parent
	assert(initial_state, parent.name + " needs an initial state to be set")
	current_state = initial_state
	current_state.enter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state:
		current_state._update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state._physics_update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state or new_state_name.to_lower() == state.name.to_lower():
		return
	
	if current_state:
		current_state._exit()
	
	new_state._enter()
	current_state = new_state

## Attempt to force the state machine to switch to a state with the given name.
## Returns true if the state successfully changed, false otherwise
func attempt_force_state_change(new_state_name: String) -> bool:
	if current_state:
		return current_state._force_state_switch(new_state_name)
	return false
