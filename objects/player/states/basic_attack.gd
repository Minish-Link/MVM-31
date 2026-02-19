extends State

## How long the hitbox of the attack should stay active for.
## Note that the hitbox will be deactivated prematurely when the character changes to a different state
@export var attack_duration := 0.5
@export var damage_box: DamageBoxComponent

func enter_state() -> void:
	damage_box.activate()

func exit_state() -> void:
	if damage_box:
		damage_box.deactivate()

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
