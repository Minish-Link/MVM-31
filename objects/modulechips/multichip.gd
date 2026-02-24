extends Node
class_name MultiChip

@export var upgrade_modules: Array[UpgradeModule]
var module_colors: Dictionary[String, UpgradeModule]
var current_module: UpgradeModule
var current_color: String = ""

@export var module_icon: Sprite2D

func _ready() -> void:
	for module in upgrade_modules:
		module_colors[module.color.to_lower()] = module
	current_module = null

## Returns true if the multichip can be equipped
func equip(color_name: String) -> bool:
	if color_name.to_lower() in module_colors.keys():
		# Fail to equip if the chosen module is already equipped to the given color.
		if current_module and current_module.color.to_lower() == color_name.to_lower():
			return false
		
		if current_module:
			current_module._on_unequip()
		
		current_module = module_colors[color_name.to_lower()]
		current_module._on_equip()
		current_color = current_module.color.to_lower()
		return true
	return false

## Returns true if the multichip can be unequipped
func unequip() -> bool:
	if not current_module:
		return false
	
	current_module._on_unequip()
	current_module = null
	current_color = ""
	return true

func update(delta: float) -> void:
	if current_module:
		current_module._update(delta)

func physics_update(delta: float) -> void:
	if current_module:
		current_module._physics_update( delta)

func modify_attack(attack: AttackData) -> AttackData:
	if not current_module:
		return attack
	return current_module._modify_attack(attack)

func modify_projectile() -> void:
	# TODO
	if not current_module:
		return
	current_module._modify_projectile()
