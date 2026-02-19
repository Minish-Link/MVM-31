extends Area3D
class_name HitboxComponent

@export var health_component: HealthComponent

## Hitboxes of a certain team can't be damaged by damage boxes of the same team.
## A value of None is not on any team, and can damage or be damaged by anything.
@export var team: Constants.Teams = Constants.Teams.NONE

func take_damage(attack: AttackData):
	if health_component:
		health_component.take_damage(attack.damage)

func set_team(new_team: Constants.Teams):
	team = new_team

func on_same_team(other_team: Constants.Teams) -> bool:
	if team == Constants.Teams.NONE:
		return false
	else:
		return team == other_team
