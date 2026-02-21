extends Node3D

@export var hitbox: HitboxComponent
@export var health: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if health:
		health.HealthDepleted.connect(queue_free)
	if hitbox:
		hitbox.health_component = health
