@abstract
extends Node
class_name State

signal Transitioned(state: State, new_state_name: String)
var parent: CharacterBody3D

## A list of each state that this state is allowed to transition to.
## Drag and drop the desired states from the Scene Tree into this array to add it.
## Attempting to enter a new state not listed here will result in staying in the current state
@export var allowed_exit_states: Array[State] = []
var allowed_exit_state_names: Array[String] = []

func _ready() -> void:
	for _state in allowed_exit_states:
		allowed_exit_state_names.append(_state.name.to_lower())

## This is called each time this state is entered from a different state
func _enter() -> void:
	pass

## This is called when a different state is entered from this one.
func _exit() -> void:
	pass

## This is called each frame while this state is the active one.
func _update(delta: float) -> void:
	pass

## This is called each physics frame while this state is the active one.
func _physics_update(delta: float) -> void:
	pass

## Attempts to force the current state to switch to a given state.
## The state will only be switched if the new state is in the current state's allowed_exit_states.
## Returns true if the state is able to switch to the given state
func _force_state_switch(new_state_name: String) -> bool:
	if new_state_name.to_lower() in allowed_exit_state_names:
		Transitioned.emit(self, new_state_name.to_lower())
		return true
	return false
