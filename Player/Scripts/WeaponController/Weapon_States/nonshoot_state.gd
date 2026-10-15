extends State

var weaponc: WeaponController:
	get: return parent as WeaponController
	set(value): weaponc = value

func process_physics(delta: float):
	if InputHandler.is_action_buffered("shoot"):
		InputHandler.clear_action_buffer("shoot")
		change_state("shoot")
		return
