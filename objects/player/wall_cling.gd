extends State

var cling_cooldown: Timer
var cling_fall_delay_timer: Timer
@export var cling_cooldown_time: float = 0.2
@export var wall_jump_force := 5.0
@export var CLING_GRAVITY := -9.8
@export var CLING_FAST_FALL_MULTIPLIER := 2.0
@export var CLING_FAST_FALL_MIN_GRAVITY := -4.9
@export var CLING_FALL_DELAY := 0.2

var can_fall := false

var direction_away_from_wall := 0.0

func _ready() -> void:
	super._ready()
	if not cling_cooldown:
		cling_cooldown = Timer.new()
		add_child(cling_cooldown)
		cling_cooldown.one_shot = true
		cling_cooldown.autostart = false
		cling_cooldown.timeout.connect(_end_cooldown)
	if not cling_fall_delay_timer:
		cling_fall_delay_timer = Timer.new()
		add_child(cling_fall_delay_timer)
		cling_fall_delay_timer.one_shot = true
		cling_cooldown.autostart = false
		cling_fall_delay_timer.timeout.connect(_start_cling_fall)

func _enter() -> void:
	print("entering wall cling state")
	can_fall = false
	if parent is PlayerCharacter:
		parent.can_fall = false
		parent.velocity.y = 0
	direction_away_from_wall = (parent as PlayerCharacter).wall_direction * -1.0
	cling_fall_delay_timer.start(CLING_FALL_DELAY)

func _exit() -> void:
	if parent is PlayerCharacter:
		parent.can_fall = true
	allowed_to_enter = false
	cling_cooldown.start(cling_cooldown_time)

func _physics_update(delta: float) -> void:
	if not can_fall and Input.get_axis("move_down", "move_up") < -0.1:
		can_fall = true # Force Falling to start if player presses down
	
	if can_fall:
		if Input.get_axis("move_down", "move_up") < -0.1:
			parent.velocity.y += CLING_GRAVITY * delta * CLING_FAST_FALL_MULTIPLIER
			parent.velocity.y = min(CLING_FAST_FALL_MIN_GRAVITY, parent.velocity.y)
		else:
			parent.velocity.y += CLING_GRAVITY * delta
	Transitioned.emit(self, (parent as Player).get_next_move_state())

func _end_cooldown() -> void:
	allowed_to_enter = true

func _start_cling_fall() -> void:
	print("I'm falling!")
	can_fall = true

func _get_walljump_velocity() -> Vector3:
	if cling_cooldown.is_stopped():
		return Vector3.ZERO
	else:
		return Vector3(direction_away_from_wall * wall_jump_force, 0.0, 0.0)
