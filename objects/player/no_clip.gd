extends State

func _update(delta: float) -> void:
	if not PlayerCharacter.noclip_enabled:
		Transitioned.emit(self, PlayerCharacter.get_next_move_state())

func _enter() -> void:
	print("entering noclip state")
	PlayerCharacter.set_collision(false)

func _exit() -> void:
	PlayerCharacter.set_collision(true)
