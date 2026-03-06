extends State

var cling_cooldown: Timer
@export var cling_cooldown_time: float = 0.2
@export var wall_jump_force := 5.0

var direction_away_from_wall := 0.0

func _ready() -> void:
	super._ready()
	if not cling_cooldown:
		cling_cooldown = Timer.new()
		add_child(cling_cooldown)
		cling_cooldown.one_shot = true
		cling_cooldown.autostart = false
		cling_cooldown.timeout.connect(_end_cooldown)

func _enter() -> void:
	print("entering wall cling state")
	if parent is PlayerCharacter:
		parent.can_fall = false
		parent.velocity.y = 0
	direction_away_from_wall = parent.get_wall_normal().x

func _exit() -> void:
	if parent is PlayerCharacter:
		parent.can_fall = true
	allowed_to_enter = false
	cling_cooldown.start(cling_cooldown_time)

func _physics_update(_delta: float) -> void:
	Transitioned.emit(self, (parent as Player).get_next_move_state())

func _end_cooldown() -> void:
	allowed_to_enter = true

func _get_walljump_velocity() -> Vector3:
	if cling_cooldown.is_stopped():
		return Vector3.ZERO
	else:
		return Vector3(direction_away_from_wall * wall_jump_force, 0.0, 0.0)
