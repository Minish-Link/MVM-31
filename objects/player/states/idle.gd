extends State

func enter() -> void:
	print("entering idle state")
	if parent is Player:
		parent.current_walk_speed = parent.WALK_SPEED

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("slide") and (parent as Player).input_dir.x != 0:
		Transitioned.emit(self, "slide")
	elif event.is_action_pressed("jump"):
		Transitioned.emit(self, "jump")
