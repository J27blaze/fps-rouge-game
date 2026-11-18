extends State

var weaponc: WeaponController:
	get: return parent as WeaponController
	set(value): weaponc = value

var burst_fired: int = 1

func start():
	burst_fired = 1
	timer_reset()
	
	EventHandler.call_event(Event.Type.PLAYER_SHOOT)
	weaponc.shoot()

func process_physics(delta: float) -> void:
	if burst_fired < weaponc.cur_weapon.resource.base_burst_fire_amount && weaponc.cur_weapon.resource.is_burst_fire:
		if timer >= weaponc.cur_weapon.resource.base_burst_fire_interval:
			burst_fired += 1
			timer_reset()
			
			EventHandler.call_event(Event.Type.PLAYER_SHOOT)
			weaponc.shoot()
	else:
		if timer >= weaponc.cur_weapon.resource.base_fire_rate:
			change_state("nonshoot")
			return
