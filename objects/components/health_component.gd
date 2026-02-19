extends Node
class_name HealthComponent

@export var MAX_HEALTH := 100.0
var current_health: float

func _ready():
	current_health = MAX_HEALTH

func take_damage(damage: float):
	current_health -= damage
