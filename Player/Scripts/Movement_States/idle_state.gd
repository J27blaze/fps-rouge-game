extends State

var player: Player:
	get: return parent as Player
	set(value): player = value

func start():
	player.target_speed = 0

func exit():
	pass

func process_physics(delta: float):
	player.vel_move_toward(Vector3.ZERO, player.run_deccel, delta)
	if player.direction != Vector3.ZERO:
		change_state("run")
		return
	if player.state_check_jump(): return
