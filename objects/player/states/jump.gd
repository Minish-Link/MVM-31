extends State

func _enter() -> void:
	print("entering jump state")

func _physics_update(delta: float) -> void:
	if parent.velocity.y <= 0.0:
		Transitioned.emit(self, "fall")
