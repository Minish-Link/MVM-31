extends CharacterBody3D

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

@export_category("Sliding")
@export var SLIDE_TIME := 0.5
@export var SLIDE_SPEED := 8.0
@export var SLIDE_DECAY_DELAY := 0.2
@export var SLIDE_DECAY_RATE := 5.0
var is_sliding := false
var stop_sliding := false
var slide_countdown := 0.0
var slide_decay_countdown := 0.0
var slide_dir := 0.0

func _ready() -> void:
	current_walk_speed = WALK_SPEED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if is_sliding:
			slide_countdown = 0.0
			stop_sliding = true
		coyote_countdown -= delta
	else:
		coyote_countdown = COYOTE_TIME
		if not is_sliding:
			slide_decay_countdown -= delta
			if slide_decay_countdown <= 0.0:
				current_walk_speed = move_toward(current_walk_speed, WALK_SPEED, delta * SLIDE_DECAY_RATE)
	
	slide_countdown -= delta
	if stop_sliding and _can_unslide():
		stop_sliding = false
		is_sliding = false
		_squish()
	
	
	# Handle jump.
	jump_timer -= delta
	if not Input.is_action_pressed("jump") and not is_on_floor() and velocity.y > 0 and jump_timer <= 0:
		velocity.y = move_toward(velocity.y, 0.0, delta*JUMP_BRAKE_SPEED)
	if Input.is_action_just_pressed("jump") and coyote_countdown > 0 and not %CeilingChecker.is_colliding():
		velocity.y = JUMP_VELOCITY
		jump_timer = MINIMUM_JUMP_TIME
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	if not is_sliding:
		if direction:
			velocity.x = move_toward(velocity.x, direction.x * current_walk_speed, ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, BRAKE_SPEED * delta)
	else:
		velocity.x = slide_dir * current_walk_speed

	move_and_slide()

func _input(event: InputEvent):
	if event.is_action_pressed("slide") and velocity.x != 0 and is_on_floor():# and not is_sliding:
		if not is_sliding:
			slide_dir = Input.get_axis("move_left", "move_right")
			is_sliding = true
			slide_countdown = SLIDE_TIME
			current_walk_speed = SLIDE_SPEED
			_squish()
		else:
			stop_sliding = false
	elif event.is_action_released("slide"):
		if _can_unslide():
			is_sliding = false
			_squish()
		else:
			stop_sliding = true

# Change the player's hitbox to match whether they are sliding or not
func _squish():
	if is_sliding:
		position.y -= 0.5
		%CollisionShape3D.shape.height = 0.9
		%MeshInstance3D.mesh.height = 1.0
	else:
		#position.y += 0.75
		%CollisionShape3D.shape.height = 1.8
		%MeshInstance3D.mesh.height = 2.0

func _can_unslide() -> bool:
	if slide_countdown > 0.0:
		return false
	if %CeilingChecker.is_colliding():
		return false
	return true
