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
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
