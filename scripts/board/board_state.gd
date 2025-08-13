class_name BoardState
extends RefCounted

var grid_width: int
var grid_height: int
var cells: Array

func _init(_w: int, _h: int, _cells: Array):
	grid_width = _w
	grid_height = _h
	cells = _cells

func update(fields: Dictionary) -> void:
	for key in fields.keys():
		if key in self:
			self.set(key, fields[key])
