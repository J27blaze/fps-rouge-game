extends ModiferBehaviour

func on_receive_event(event: Event.Type) -> void:
	if randi_range(1, 2) == 2 && modifer.active:
		damage_flat_increase += 1
		print("dfsdf")
