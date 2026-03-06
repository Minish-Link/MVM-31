extends ProgressBar

#func _ready() -> void:
#	PlayerCharacter.health_component.on_health_changed.connect(update_health)

func update_health(_health: float, _max_health: float) -> void:
	value = clamp(_health / _max_health, 0.0, 1.0) * 100.0
