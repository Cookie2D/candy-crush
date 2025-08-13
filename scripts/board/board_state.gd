class_name BoardState
extends RefCounted

var grid_width: int
var grid_height: int
var gap_percentage: float
var cells: Array = []
var pressedItem: Node3D = null

func _init(_w: int, _h: int, _gap):
	grid_width = _w
	grid_height = _h
	gap_percentage = _gap

func update(fields: Dictionary) -> void:
	for key in fields.keys():
		if key in self:
			self.set(key, fields[key])
