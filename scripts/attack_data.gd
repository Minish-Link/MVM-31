extends Node
class_name AttackData

var damage := 1.0
var ignores_invulnerability := false

var knockback_force := 0.0
# What direction and speed to push the target away. Determined in calculate_knockback()
var knockback_velocity := Vector3.ZERO
# The point in space from which to push the target away
var knockback_origin := Vector3.ZERO
# The position of the target
var knockback_target := Vector3.ZERO
# how much the knockback force decreases with distance (decreases by this rate for each unit away from the origin)
var knockback_falloff_rate := 0.0

func _init(_damage: float, _ignores_invulnerable: bool = false, _knockback_force: float = 0.0, _knockback_from: Vector3 = Vector3.ZERO, _knockback_toward: Vector3 = Vector3.ZERO, _knockback_falloff = 0.0):
	damage = _damage
	ignores_invulnerability = _ignores_invulnerable
	knockback_force = _knockback_force
	knockback_origin = _knockback_from
	knockback_target = _knockback_toward
	knockback_falloff_rate = _knockback_falloff
	if knockback_force > 0:
		calculate_knockback()

# Attack Data only needs to exist for the frame an attack deals damage, so we free it in the next frame
func _ready() -> void:
	queue_free()

## using the attack's knockback force, falloff rate, and the positions of the attack and the target,
## calculates the force and direction of the knockback
func calculate_knockback():
	var knockback_direction = knockback_target - knockback_origin
	knockback_force = max(0, knockback_force - (knockback_direction.length() * knockback_falloff_rate))
	knockback_velocity = knockback_direction.normalized() * knockback_force
