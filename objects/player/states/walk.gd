extends State

@export var SPEED_DECAY_DELAY := 0.2
@export var SPEED_DECAY_RATE := 2.0
var speed_decay_countdown := 0.0

func enter() -> void:
	print("entering walk state")
	speed_decay_countdown = SPEED_DECAY_DELAY

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	speed_decay_countdown -= delta
	if parent is Player and speed_decay_countdown <= 0.0:
		parent.current_walk_speed = move_toward(parent.current_walk_speed, parent.WALK_SPEED, SPEED_DECAY_RATE * delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("slide") and (parent as Player).input_dir.x != 0:
		Transitioned.emit(self, "slide")
	elif event.is_action_pressed("jump"):
		Transitioned.emit(self, "jump")
