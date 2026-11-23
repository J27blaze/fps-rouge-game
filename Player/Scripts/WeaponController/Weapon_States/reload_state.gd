extends State

var weaponc: WeaponController:
	get: return parent as WeaponController
	set(value): weaponc = value

func start() -> void:
	EventHandler.call_event(Event.Type.PLAYER_START_RELOAD)
	timer_reset()

func process_frame(delta: float) -> void:
	if InputHandler.is_action_buffered("weapon_change_up"):
		InputHandler.clear_action_buffer("weapon_change_up")
		change_state("change_weapon", 1)
		return
	if InputHandler.is_action_buffered("weapon_change_down"):
		InputHandler.clear_action_buffer("weapon_change_down")
		change_state("change_weapon", -1)
		return
	
	if timer >= weaponc.cur_weapon.resource.base_reload_length:
		EventHandler.call_event(Event.Type.PLAYER_END_RELOAD)
		
		weaponc.reload()
		change_state("nonshoot")
		return
