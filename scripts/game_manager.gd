extends Node

signal fruit_click(fruit: Node3D)

var board_state: BoardState

func set_board_state(state: Dictionary)-> void:
	board_state.update(state)

func get_board_state() -> BoardState:
	return board_state
