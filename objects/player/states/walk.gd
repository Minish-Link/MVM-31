extends State

@export var SPEED_DECAY_DELAY := 0.2
@export var SPEED_DECAY_RATE := 2.0
var speed_decay_countdown := 0.0

func _enter() -> void:
	print("entering walk state")
	speed_decay_countdown = SPEED_DECAY_DELAY

func _physics_update(delta: float) -> void:
	speed_decay_countdown -= delta
	if parent is Player and speed_decay_countdown <= 0.0:
		parent.current_walk_speed = move_toward(parent.current_walk_speed, parent.WALK_SPEED, SPEED_DECAY_RATE * delta)
	Transitioned.emit(self, (parent as Player).get_next_move_state())
