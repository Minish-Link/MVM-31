extends Node
class_name HealthComponent

signal on_damaged(damage: float)
signal on_health_changed(_cur_health: float, _max_health: float)
signal on_death()

@export var MAX_HEALTH := 100.0
var current_health: float:
	set(value):
		current_health = value
		on_health_changed.emit(current_health, MAX_HEALTH)
		
var max_health_premultipliers: float
var health_multipliers: Dictionary[String, float]

func _ready():
	current_health = MAX_HEALTH
	max_health_premultipliers = MAX_HEALTH

func take_damage(damage: float):
	current_health -= damage
	on_damaged.emit(damage)
	if current_health <= 0.0:
		on_death.emit()

func add_max_health(health: float):
	max_health_premultipliers += health
	_calculate_final_max_health()

## Adds a multiplier to the health component, with the given key. If a multiplier with the given key
## already exists on this component, it will fail to add the multiplier and return false
func add_health_multiplier(new_multiplier: float, mult_key: String) -> bool:
	if mult_key in health_multipliers:
		push_warning("A multiplier key of %s already exists on this health component" % mult_key)
		return false
	
	health_multipliers[mult_key] = new_multiplier
	_calculate_final_max_health()
	return true

## Attempts to remove a multiplier with the given key. Returns true if the multiplier existed
## Returns false otherwise.
func remove_health_multiplier(mult_key: String) -> bool:
	if mult_key in health_multipliers.keys():
		health_multipliers.erase(mult_key)
		_calculate_final_max_health()
		return true
	return false

func _calculate_final_max_health():
	var previous_max_health = MAX_HEALTH
	
	MAX_HEALTH = max_health_premultipliers
	for multiplier in health_multipliers.values():
		MAX_HEALTH *= multiplier
	
	if MAX_HEALTH > previous_max_health:
		current_health += MAX_HEALTH - previous_max_health
	if current_health > MAX_HEALTH:
		current_health = MAX_HEALTH

## Heals the player by the given amount. Returns true if the character was healed, and
## false if the character was already at full health
func heal(amount: float) -> bool:
	if current_health >= MAX_HEALTH:
		return false
	current_health += amount
	if current_health > MAX_HEALTH:
		current_health = MAX_HEALTH
	return true

## Sets the character's current health to its max health
func fully_heal():
	current_health = MAX_HEALTH
