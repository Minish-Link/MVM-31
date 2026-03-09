@tool
extends Node3D

@export var BOTTOM_LEFT_BOUNDARY: Node3D
@export var TOP_RIGHT_BOUNDARY: Node3D

@export_category("World Map Size")
const SINGLE_ROOM_WIDTH := 24.0
const SINGLE_ROOM_HEIGHT := 16.0
const ROOM_WIDTH_OFFSET := SINGLE_ROOM_WIDTH / 2.0
const ROOM_HEIGHT_OFFSET := SINGLE_ROOM_HEIGHT / 2.0

@export var MAP_RIGHT: int = 0:
	set(value):
		MAP_RIGHT = value
		if not setting_up:
			if MAP_LEFT > MAP_RIGHT:
				MAP_LEFT = MAP_RIGHT
			right_boundary = MAP_RIGHT * SINGLE_ROOM_WIDTH + ROOM_WIDTH_OFFSET

@export var MAP_LEFT: int = 0:
	set(value):
		MAP_LEFT = value
		if not setting_up:
			if MAP_LEFT > MAP_RIGHT:
				MAP_RIGHT = MAP_LEFT
			left_boundary = MAP_LEFT * SINGLE_ROOM_WIDTH - ROOM_WIDTH_OFFSET

@export var MAP_TOP: int = 0:
	set(value):
		MAP_TOP = value
		if not setting_up:
			if MAP_BOTTOM > MAP_TOP:
				MAP_BOTTOM = MAP_TOP
			top_boundary = MAP_TOP * SINGLE_ROOM_HEIGHT + ROOM_HEIGHT_OFFSET

@export var MAP_BOTTOM: int = 0:
	set(value):
		MAP_BOTTOM = value
		if not setting_up:
			if MAP_BOTTOM > MAP_TOP:
				MAP_TOP = MAP_BOTTOM
			bottom_boundary = MAP_BOTTOM * SINGLE_ROOM_HEIGHT - ROOM_HEIGHT_OFFSET

var setting_up := true

@export_category("Room Boundaries")
@export var left_boundary: float = -(SINGLE_ROOM_WIDTH / 2.0):
	set(value):
		left_boundary = value
		if BOTTOM_LEFT_BOUNDARY:
			BOTTOM_LEFT_BOUNDARY.position.x = value
		if setting_up:
			return
		if right_boundary < left_boundary:
			push_warning("Left Boundary should be to the left of Right Boundary")
		elif right_boundary - left_boundary < SINGLE_ROOM_WIDTH:
			push_warning("Left and Right Boundaries should be at least " + str(SINGLE_ROOM_WIDTH) + " units apart")
@export var right_boundary: float = (SINGLE_ROOM_WIDTH / 2.0):
	set(value):
		right_boundary = value
		if TOP_RIGHT_BOUNDARY:
			TOP_RIGHT_BOUNDARY.position.x = value
		if setting_up:
			return
		if right_boundary < left_boundary:
			push_warning("Right Boundary should be to the right of Left Boundary")
		elif right_boundary - left_boundary < SINGLE_ROOM_WIDTH:
			push_warning("Left and Right Boundaries should be at least " + str(SINGLE_ROOM_WIDTH) + " units apart")
@export var bottom_boundary: float = -(SINGLE_ROOM_HEIGHT / 2.0):
	set(value):
		bottom_boundary = value
		if BOTTOM_LEFT_BOUNDARY:
			BOTTOM_LEFT_BOUNDARY.position.y = value
		if setting_up:
			return
		if top_boundary < bottom_boundary:
			push_warning("Bottom Boundary should be lower than Top Boundary")
		elif top_boundary - bottom_boundary < SINGLE_ROOM_HEIGHT:
			push_warning("Top and Bottom Boundaries should be at least "+ str(SINGLE_ROOM_HEIGHT) + " units apart")
@export var top_boundary: float = (SINGLE_ROOM_HEIGHT / 2.0):
	set(value):
		top_boundary = value
		if TOP_RIGHT_BOUNDARY:
			TOP_RIGHT_BOUNDARY.position.y = value
		if setting_up:
			return
		if top_boundary < bottom_boundary:
			push_warning("Top Boundary should be higher than Bottom Boundary")
		elif top_boundary - bottom_boundary < SINGLE_ROOM_HEIGHT:
			push_warning("Top and Bottom Boundaries should be at least "+ str(SINGLE_ROOM_HEIGHT) + " units apart")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setting_up = false
	if OS.has_feature("editor_hint"):
		return
	assert(TOP_RIGHT_BOUNDARY.position.x > BOTTOM_LEFT_BOUNDARY.position.x,
	"Right Camera Boundary must be to the right of the Left Camera Boundary")
	assert(TOP_RIGHT_BOUNDARY.position.y > BOTTOM_LEFT_BOUNDARY.position.y,
	"Bottom Camera Boundary must be below the Top Camera Boundary")
	assert(TOP_RIGHT_BOUNDARY.position.x - BOTTOM_LEFT_BOUNDARY.position.x >= SINGLE_ROOM_WIDTH,
	"Left and Right Camera Boundaries must be at least " + str(SINGLE_ROOM_WIDTH) + " units apart")
	assert(TOP_RIGHT_BOUNDARY.position.y - BOTTOM_LEFT_BOUNDARY.position.y >= SINGLE_ROOM_HEIGHT,
	"Top and Bottom Camera Boundaries must be at least " + str(SINGLE_ROOM_HEIGHT) + " units apart")
	
	GameCamera.left_boundary = BOTTOM_LEFT_BOUNDARY.position.x
	GameCamera.right_boundary = TOP_RIGHT_BOUNDARY.position.x
	GameCamera.bottom_boundary = BOTTOM_LEFT_BOUNDARY.position.y
	GameCamera.top_boundary = TOP_RIGHT_BOUNDARY.position.y
	
	BOTTOM_LEFT_BOUNDARY.visible = false
	TOP_RIGHT_BOUNDARY.visible = false
