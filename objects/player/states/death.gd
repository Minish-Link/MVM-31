extends State

@export var death_time := 3.0

func _enter() -> void:
	var death_timer = get_tree().create_timer(death_time)
	death_timer.timeout.connect(fade_out)

func fade_out() -> void:
	pass
