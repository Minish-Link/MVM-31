extends Area3D
class_name DamageBoxComponent

## Should be set to true for environmental hazards, and false for attacks
@export var start_active := false

@export var damage := 1.0
## hitboxes of a certain team can't be damaged by damageboxes of the same team.
## a value of None is not on any team, and can damage or be damaged by anything.
@export var team: Constants.Teams = Constants.Teams.NONE

## What hitbox(es) should be ignored when dealing damage. Typically this should be
## any hitbox belonging to the character who owns this attack, to prevent potential self damage
@export var ignored_hitboxes: Array[HitboxComponent] 

func _ready() -> void:
	monitoring = start_active

func activate():
	monitoring = true

func deactivate():
	monitoring = false

func set_active(active: bool = true):
	monitoring = active

func set_damage(new_damage: float):
	damage = new_damage

func set_team(new_team: Constants.Teams):
	team = new_team

func _on_hitbox_entered(area: Area3D) -> void:
	if area is HitboxComponent and area not in ignored_hitboxes and not area.on_same_team(team):
		var attack = AttackData.new(damage)
		area.take_damage(attack)
