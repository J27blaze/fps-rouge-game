extends State

var weaponc: WeaponController:
	get: return parent as WeaponController
	set(value): weaponc = value

@export var change_speed: float = 0.6

func start() -> void:
	weaponc.player_ui.swap_anim()

func process_frame(delta: float) -> void:
	if timer > change_speed:
		weaponc.change_weapon()
		EventHandler.call_event(Event.Type.PLAYER_SWAP_WEAPON)
		change_state("nonshoot")
		return
