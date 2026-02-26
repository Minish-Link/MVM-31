extends UpgradeModule

@export var damage_multiplier := 1.25

## Multiplies the damage of the player's melee attack
func _modify_attack(attack: DamageBoxComponent):
	attack.damage *= damage_multiplier
