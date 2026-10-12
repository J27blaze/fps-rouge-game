extends Node
class_name StateMachine

@onready var all_states
@export var start_state: String
var states: Dictionary[String, State]
var cur_state: State
var prev_state: State

func init():
	all_states = get_children()
	
	for child in all_states:
		child.init()
		states[str(child.name).to_lower()] = child
	
	prev_state = states["idle"]
	print(states)
	change_state(start_state)

func change_state(new_state: String, transfer_data = null):
	if cur_state:
		cur_state.exit()
		prev_state = cur_state
		#print( current_state.name)
	#else:
	#	push_error(new_state + " does not exist.")
	cur_state = states[new_state]
	cur_state.transfer_data = transfer_data
	cur_state.start()
