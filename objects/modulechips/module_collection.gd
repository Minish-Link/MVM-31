extends Node
class_name ModuleCollection

var collection: Array[MultiChip]

func modify_attack(attack: AttackData) -> AttackData:
	for chip in collection:
		attack = chip.modify_attack(attack)
	return attack

func _process(delta: float) -> void:
	for chip in collection:
		chip.update(delta)

func _physics_process(delta: float) -> void:
	for chip in collection:
		chip.physics_update(delta)
