extends State

func enter() -> void:
	print("entering idle state")
	if parent is Player:
		parent.current_walk_speed = parent.WALK_SPEED

func _physics_update(delta: float) -> void:
	Transitioned.emit(self, (parent as Player).get_next_move_state())
