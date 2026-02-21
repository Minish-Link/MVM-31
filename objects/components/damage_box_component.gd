extends Area3D
class_name DamageBoxComponent

@export var damage := 1.0
@export var damage_ignores_invulnerability := false
@export var knockback_force := 0.0

## How much force should be lost per unit of distance that the target is away from the damage source
@export var knockback_force_falloff_rate := 0.0

## How much the origin of the knockback should be offset relative to its transform position.
## This could be useful for melee attacks that are offset from the attacking character, so that the attack
## doesn't pull the target in if they're positioned between the attack and the attacking character.
@export var knockback_origin_offset := Vector3.ZERO

## if this is set to true, then a character damaged by this will never
## be able to be damaged by it again for as long as it exists.
@export var prevent_multihit := false

## Hitboxes of a given team can't be damaged by damageboxes of the same team.
## a value of None is not on any team, and can damage or be damaged by anything.
@export var team: Constants.Teams = Constants.Teams.NONE

## What hitbox(es) should be ignored when dealing damage. Typically this should be
## any hitbox belonging to the character who owns this attack, to prevent potential self damage
@export var ignored_hitboxes: Array[HitboxComponent]

func _ready() -> void:
	monitoring = true

func set_damage(new_damage: float):
	damage = new_damage

func set_team(new_team: Constants.Teams):
	team = new_team

## Force this damage box to disappear after a given time.
## If this function is not called, the damage box will exist indefinitely
func set_duration(duration: float):
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(queue_free)
	timer.start(duration)

func _on_hitbox_entered(area: Area3D) -> void:
	if area is HitboxComponent and area not in ignored_hitboxes and not area.on_same_team(team):
		var attack = AttackData.new(
			damage,
			damage_ignores_invulnerability,
			knockback_force,
			position + knockback_origin_offset,
			area.position,
			knockback_force_falloff_rate
			)
		area.take_damage(attack)
		if prevent_multihit:
			ignored_hitboxes.append(area)
