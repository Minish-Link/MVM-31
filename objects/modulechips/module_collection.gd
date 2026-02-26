extends Node
class_name ModuleCollection

var collection: Array[MultiChip]

func modify_attack(attack: DamageBoxComponent) -> void:
	for chip in collection:
		chip.modify_attack(attack)

func modify_projectile(projectile: DamageBoxComponent) -> void:
	for chip in collection:
		chip.modify_projectile(projectile)

func _process(delta: float) -> void:
	for chip in collection:
		chip.update(delta)

func _physics_process(delta: float) -> void:
	for chip in collection:
		chip.physics_update(delta)
