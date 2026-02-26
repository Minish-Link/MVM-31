extends UpgradeModule

@export var damage_multiplier := 1.4

## Multiplies the projectile's damage
func _modify_projectile(projectile: DamageBoxComponent) -> void:
	projectile.damage *= damage_multiplier
