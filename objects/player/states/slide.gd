extends State

@export var SLIDE_MINIMUM_TIME := 0.2
@export var INITIAL_SLIDE_SPEED := 8.0
@export var SLIDE_ACCELERATION := 0.0
@export var MAX_SLIDE_SPEED := 9999.0
var current_slide_speed := 8.0
var is_sliding := false
var stop_sliding := false
var slide_countdown := 0.0
var slide_decay_countdown := 0.0
var slide_dir := 0.0

func _enter() -> void:
	print("entering slide state")
	if parent is Player:
		parent.horizontal_input_allowed = false
		slide_dir = parent.input_dir.normalized().x
		current_slide_speed = max(INITIAL_SLIDE_SPEED, parent.current_walk_speed)
	slide_countdown = SLIDE_MINIMUM_TIME
	# squish the player's collision and hitbox
	parent.position.y -= 0.5
	%CollisionShape3D.shape.height *= 0.5
	%MeshInstance3D.mesh.height *= 0.5

func _exit() -> void:
	if parent is Player:
		parent.horizontal_input_allowed = true
		parent.current_walk_speed = current_slide_speed
	# unsquish the player's collision and hitbox
	%CollisionShape3D.shape.height *= 2.0
	%MeshInstance3D.mesh.height *= 2.0

func _physics_update(delta: float) -> void:
	current_slide_speed += SLIDE_ACCELERATION * delta * 0.5
	if current_slide_speed > MAX_SLIDE_SPEED:
		current_slide_speed = MAX_SLIDE_SPEED
	parent.velocity.x = current_slide_speed * slide_dir
	current_slide_speed += SLIDE_ACCELERATION * delta * 0.5
	
	slide_countdown -= delta
	if slide_countdown <= 0.0 and stop_sliding and not %CeilingChecker.is_colliding():
		if (parent as Player).input_dir.x != 0:
			Transitioned.emit(self, "walk")
		else:
			Transitioned.emit(self, "idle")
	if not parent.is_on_floor():
		Transitioned.emit(self, "fall")

func _input(event: InputEvent) -> void:
	if event.is_action_released("slide"):
		stop_sliding = true
	elif event.is_action_pressed("slide"):
		stop_sliding = false
