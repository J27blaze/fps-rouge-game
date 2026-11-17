extends State

var weaponc: WeaponController:
	get: return parent as WeaponController
	set(value): weaponc = value

func process_frame(delta: float):
	if InputHandler.is_action_buffered("shoot") || (weaponc.cur_weapon.is_automatic && Input.is_action_pressed("shoot")):
		InputHandler.clear_action_buffer("shoot")
		if weaponc.cur_weapon.cur_mag_size <= 0:
			change_state("reload")
		else:
			change_state("shoot")
		return
	
	if InputHandler.is_action_buffered("reload"):
		InputHandler.clear_action_buffer("reload")
		change_state("reload")
		return
	
	if InputHandler.is_action_buffered("weapon_change_up"):
		InputHandler.clear_action_buffer("weapon_change_up")
		change_state("change_weapon", 1)
		return
	if InputHandler.is_action_buffered("weapon_change_down"):
		InputHandler.clear_action_buffer("weapon_change_down")
		change_state("change_weapon", -1)
		return
