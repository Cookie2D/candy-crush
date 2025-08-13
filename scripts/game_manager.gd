extends Node

var _board_state: BoardState = BoardState.new(8, 8, 0.05)

func set_board_state(state: BoardState)-> void:
	_board_state = state

func update_board_state(partial: Dictionary)-> void:
	_board_state.update(partial)

func get_board_state() -> BoardState:
	return _board_state
