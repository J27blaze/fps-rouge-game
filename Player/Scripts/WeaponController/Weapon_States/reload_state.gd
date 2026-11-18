extends State

var weaponc: WeaponController:
	get: return parent as WeaponController
	set(value): weaponc = value

func start() -> void:
	EventHandler.call_event(Event.PLAYER_START_RELOAD)
	timer_reset()

func process_frame(delta: float) -> void:
	if timer >= weaponc.cur_weapon.resource.base_reload_length:
		EventHandler.call_event(Event.PLAYER_END_RELOAD)
		
		weaponc.reload()
		change_state("nonshoot")
		return
