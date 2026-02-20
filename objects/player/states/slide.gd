extends State

@export var SLIDE_MINIMUM_TIME := 0.2
@export var SLIDE_SPEED := 8.0
var is_sliding := false
var stop_sliding := false
var slide_countdown := 0.0
var slide_decay_countdown := 0.0
var slide_dir := 0.0

func enter() -> void:
	print("entering slide state")
	if parent is Player:
		parent.horizontal_input_allowed = false
		slide_dir = parent.input_dir.normalized().x
	slide_countdown = SLIDE_MINIMUM_TIME
	# squish the player's collision and hitbox
	parent.position.y -= 0.5
	%CollisionShape3D.shape.height *= 0.5
	%MeshInstance3D.mesh.height *= 0.5

func exit() -> void:
	if parent is Player:
		parent.horizontal_input_allowed = true
		parent.current_walk_speed = SLIDE_SPEED
	# unsquish the player's collision and hitbox
	%CollisionShape3D.shape.height *= 2.0
	%MeshInstance3D.mesh.height *= 2.0

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	parent.velocity.x = SLIDE_SPEED * slide_dir
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
	if event.is_action_pressed("jump"):
		Transitioned.emit(self, "jump")
