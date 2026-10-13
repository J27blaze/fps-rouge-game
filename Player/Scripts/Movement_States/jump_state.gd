extends State

var prev_vel: Vector3 = Vector3.ZERO
var start_speed: float = 0.0

var player: Player:
	get: return parent as Player
	set(value): player = value

func start():
	player.velocity.y = player.jump_pulse
	prev_vel = player.hor_velocity
	
	start_speed = player.speed

func exit():
	pass

func process_physics(delta: float):
	var move_dir: Vector3 = player.direction
	var input_dir: Vector3 = move_dir.normalized()
	
	
	prev_vel = player.hor_velocity
	DebugDraw3D.draw_line(player.position, player.position + prev_vel, Color.BLUE)
	
	if player.state_check_land(): return
