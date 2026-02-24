@abstract
extends Resource
class_name UpgradeModule

@export var color : String = ""

## Gets called everytime a projectile attack is created. Returns the modified projectile
func _modify_projectile() -> void:
	pass

## Gets called everytime a melee attack is created
func _modify_attack(attack: AttackData) -> AttackData:
	return attack

## Gets called when the module is equipped
func _on_equip() -> void:
	pass

## Gets called when the module is uneqipped
func _on_unequip() -> void:
	pass

## Gets called every frame while the module is equipped
func _update(delta: float) -> void:
	pass

func _physics_update(delta: float) -> void:
	pass
