extends CharacterBody3D
class_name Player

var state_machine: StateMachine

@export_category("Basic Movement")
@export var WALK_SPEED := 5.0
@export var ACCELERATION := 30.0
@export var BRAKE_SPEED := 20.0
@export var JUMP_VELOCITY := 4.5
var current_walk_speed := 5.0
@export var COYOTE_TIME := 0.2
var coyote_countdown := 0.0
@export var MINIMUM_JUMP_TIME := 0.5
@export var JUMP_BRAKE_SPEED := 20.0
var jump_timer := 0.0

var horizontal_input_allowed := true
var can_fall := true
var input_dir := Vector2.ZERO
# 1 for right, -1 for left
var facing_dir := 1.0

var can_attack := true

func _ready() -> void:
	#state_machine.sm_init(self)
	state_machine = get_node("StateMachine")
	state_machine.sm_init(self)
	current_walk_speed = WALK_SPEED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if coyote_countdown > 0:
			coyote_countdown -= delta
		if can_fall:
			velocity += get_gravity() * delta
	else:
		coyote_countdown = COYOTE_TIME
	
	# Handle jump.
	jump_timer -= delta
	if not Input.is_action_pressed("jump") and not is_on_floor() and velocity.y > 0 and jump_timer <= 0:
		velocity.y = move_toward(velocity.y, 0.0, delta*JUMP_BRAKE_SPEED)
	if Input.is_action_just_pressed("jump") and coyote_countdown > 0 and not %CeilingChecker.is_colliding():
		velocity.y = JUMP_VELOCITY
		jump_timer = MINIMUM_JUMP_TIME
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := transform.basis * Vector3(input_dir.x, 0, 0)
	
	# If the player is attempting to move in the opposite direction of their velocity, remove all bonus speed
	if direction.x * velocity.x <= 0.0:
		current_walk_speed = WALK_SPEED
	
	if horizontal_input_allowed:
		if direction:
			velocity.x = move_toward(velocity.x, direction.x * current_walk_speed, ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, BRAKE_SPEED * delta)
	
	if velocity.x > 0:
		facing_dir = 1.0
	elif velocity.x < 0:
		facing_dir = -1.0

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("slide"):
		state_machine.attempt_force_state_change("slide")
	elif event.is_action_pressed("attack"):
		state_machine.attempt_force_state_change("basicattack")

func get_next_move_state() -> String:
	if not is_on_floor():
		return "fall"
	elif abs(input_dir.x) > 0.1:
		return "walk"
	else:
		return "idle"
