extends State

var player: Player:
	get: return parent as Player
	set(value): player = value

var cur_accel: float = 0.0

func start():
	pass

func exit():
	pass

func process_physics(delta: float):
	var move_dir: Vector3
	if timer < 0.1:
		move_dir = clampf(player.target_speed, player.run_speed, 999999) * player.direction
		if player.speed > player.run_speed: cur_accel = 0 
		else: cur_accel = player.run_accel
	else:
		move_dir = player.run_speed * player.direction
		player.target_speed = player.run_speed
		
		cur_accel = player.run_accel
	
	player.vel_move_toward(move_dir, player.run_accel, delta)
	
	if player.direction == Vector3.ZERO:
		change_state("idle")
		return
	if player.state_check_jump(): return
