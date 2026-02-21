extends State

# This state is primarily for animation purposes and is not required for the player to be affected by gravity

func _enter() -> void:
	print("entering fall state")

func _physics_update(delta: float) -> void:
	Transitioned.emit(self, (parent as Player).get_next_move_state())
