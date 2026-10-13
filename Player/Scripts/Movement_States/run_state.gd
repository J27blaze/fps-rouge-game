extends State

var player: Player:
	get: return parent as Player
	set(value): player = value

func start():
	pass

func exit():
	pass

func process_physics(delta: float):
	var move_dir: Vector3 = player.run_speed * player.direction
	player.vel_move_toward(move_dir, player.run_accel, delta)
	if player.direction == Vector3.ZERO:
		change_state("idle")
		return
	if player.state_check_jump(): return
