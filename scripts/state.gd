@abstract
extends Node
class_name State

signal Transitioned(state: State, new_state_name: String)
var parent: CharacterBody3D

func enter_state():
	pass

func exit_state():
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
