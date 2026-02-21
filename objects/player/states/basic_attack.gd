extends State

@export var slash_effect := preload("res://objects/player/SlashEffect.tscn")

@export_category("Attack Stats")
## How long the hitbox of the attack should stay active for.
## Note that the hitbox will be deactivated prematurely when the character changes to a different state
@export var ATTACK_DURATION := 0.1
@export var ATTACK_COOLDOWN := 0.5
@export var ATTACK_DELAY := 0.1
@export var ATTACK_DAMAGE := 1.0

@export_category("Timers")
@export var delay_timer: Timer
@export var cooldown_timer: Timer
@export var exit_timer: Timer

var current_attack: DamageBoxComponent

func _ready() -> void:
	delay_timer.timeout.connect(create_attack)
	cooldown_timer.timeout.connect(end_cooldown)
	exit_timer.timeout.connect(end_attack)

func _enter() -> void:
	print("entering attack state")
	delay_timer.start(ATTACK_DELAY)
	exit_timer.start(ATTACK_DELAY + ATTACK_DURATION)
	cooldown_timer.start(ATTACK_COOLDOWN)
	if parent is Player:
		parent.can_attack = false

func _exit() -> void:
	if current_attack:
		current_attack.free()
	delay_timer.stop()
	exit_timer.stop()



func end_cooldown() -> void:
	if parent is Player:
		parent.can_attack = true

func end_attack() -> void:
	print("ending attack")
	Transitioned.emit(self, (parent as Player).get_next_move_state())

func create_attack():
	print("creating attack")
	current_attack = slash_effect.instantiate()
	parent.add_child(current_attack)
	current_attack.position += (parent as Player).facing_dir * %WeaponOffset.position
	current_attack.set_duration(ATTACK_DURATION)
	current_attack.set_damage(ATTACK_DAMAGE)
