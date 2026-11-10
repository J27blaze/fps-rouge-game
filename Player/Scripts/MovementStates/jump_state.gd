extends State
var player: Player:
	get: return parent as Player
	set(value): player = value

func start():
	player.velocity.y = player.jump_pulse
	
func exit():
	pass

func process_physics(delta: float):
	var move_dir: Vector3 = player.direction
	var new_vel = player.vel_air_strafe(player.hor_velocity, move_dir, delta)
	player.velocity.x = new_vel.x
	player.velocity.z = new_vel.z
	
	player.target_speed = new_vel.length()
	
	if player.state_check_land(): return
