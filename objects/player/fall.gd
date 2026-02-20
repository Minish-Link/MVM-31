extends State

# This state is primarily for animation purposes and is not required for the player to be affected by gravity

func enter() -> void:
	print("entering fall state")

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	if parent.is_on_floor():
		if abs(parent.velocity.x) <= 0.1:
			Transitioned.emit(self, "idle")
		else:
			Transitioned.emit(self, "walk")

#func _input(event: InputEvent) -> void:
	#
