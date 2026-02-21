extends Node
class_name HealthComponent

@export var MAX_HEALTH := 100.0
var current_health: float

signal Damaged(damage: float)
signal HealthDepleted

func _ready():
	current_health = MAX_HEALTH

func take_damage(damage: float):
	current_health -= damage
	Damaged.emit(damage)
	if current_health <= 0.0:
		HealthDepleted.emit()
