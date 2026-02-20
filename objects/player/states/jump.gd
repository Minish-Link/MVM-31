extends State

func enter() -> void:
	print("entering jump state")
	pass

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	if parent.velocity.y <= 0.0:
		Transitioned.emit(self, "fall")
