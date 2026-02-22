@tool
extends Node3D

@export var BOTTOM_LEFT_BOUNDARY: Node3D
@export var TOP_RIGHT_BOUNDARY: Node3D
@export var BOUNDARY_MINIMUM_WIDTH: float = 16.0
@export var BOUNDARY_MINIMUM_HEIGHT: float = 12.0

@export var left_boundary: float = -8.0:
	set(value):
		left_boundary = value
		if BOTTOM_LEFT_BOUNDARY:
			BOTTOM_LEFT_BOUNDARY.position.x = value
		if right_boundary < left_boundary:
			push_warning("Left Boundary should be to the left of Right Boundary")
		elif right_boundary - left_boundary < BOUNDARY_MINIMUM_WIDTH:
			push_warning("Left and Right Boundaries should be at least " + str(BOUNDARY_MINIMUM_WIDTH) + " units apart")
@export var right_boundary: float = 8.0:
	set(value):
		right_boundary = value
		if TOP_RIGHT_BOUNDARY:
			TOP_RIGHT_BOUNDARY.position.x = value
		if right_boundary < left_boundary:
			push_warning("Right Boundary should be to the right of Left Boundary")
		elif right_boundary - left_boundary < BOUNDARY_MINIMUM_WIDTH:
			push_warning("Left and Right Boundaries should be at least " + str(BOUNDARY_MINIMUM_WIDTH) + " units apart")
@export var bottom_boundary: float = -6.0:
	set(value):
		bottom_boundary = value
		if BOTTOM_LEFT_BOUNDARY:
			BOTTOM_LEFT_BOUNDARY.position.y = value
		if top_boundary < bottom_boundary:
			push_warning("Bottom Boundary should be lower than Top Boundary")
		elif top_boundary - bottom_boundary < BOUNDARY_MINIMUM_HEIGHT:
			push_warning("Top and Bottom Boundaries should be at least "+ str(BOUNDARY_MINIMUM_HEIGHT) + " units apart")
@export var top_boundary: float = 6.0:
	set(value):
		top_boundary = value
		if TOP_RIGHT_BOUNDARY:
			TOP_RIGHT_BOUNDARY.position.y = value
		if top_boundary < bottom_boundary:
			push_warning("Top Boundary should be higher than Bottom Boundary")
		elif top_boundary - bottom_boundary < BOUNDARY_MINIMUM_HEIGHT:
			push_warning("Top and Bottom Boundaries should be at least "+ str(BOUNDARY_MINIMUM_HEIGHT) + " units apart")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(TOP_RIGHT_BOUNDARY.position.x > BOTTOM_LEFT_BOUNDARY.position.x,
	"Right Camera Boundary must be to the right of the Left Camera Boundary")
	assert(TOP_RIGHT_BOUNDARY.position.y > BOTTOM_LEFT_BOUNDARY.position.y,
	"Bottom Camera Boundary must be below the Top Camera Boundary")
	assert(TOP_RIGHT_BOUNDARY.position.x - BOTTOM_LEFT_BOUNDARY.position.x >= BOUNDARY_MINIMUM_WIDTH,
	"Left and Right Camera Boundaries must be at least " + str(BOUNDARY_MINIMUM_WIDTH) + " units apart")
	assert(TOP_RIGHT_BOUNDARY.position.y - BOTTOM_LEFT_BOUNDARY.position.y >= BOUNDARY_MINIMUM_HEIGHT,
	"Top and Bottom Camera Boundaries must be at least " + str(BOUNDARY_MINIMUM_HEIGHT) + " units apart")
	
	GameCamera.left_boundary = BOTTOM_LEFT_BOUNDARY.position.x
	GameCamera.right_boundary = TOP_RIGHT_BOUNDARY.position.x
	GameCamera.bottom_boundary = BOTTOM_LEFT_BOUNDARY.position.y
	GameCamera.top_boundary = TOP_RIGHT_BOUNDARY.position.y
	
	BOTTOM_LEFT_BOUNDARY.visible = false
	TOP_RIGHT_BOUNDARY.visible = false
