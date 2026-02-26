extends Resource
class_name UpgradeModule

@export var color : String = ""
@export var description: String = "<Description Here>"

## Gets called everytime a projectile attack is created. Returns the modified projectile
func _modify_projectile(projectile: DamageBoxComponent) -> void:
	pass

## Gets called everytime a melee attack is created
func _modify_attack(attack: DamageBoxComponent) -> void:
	pass

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
