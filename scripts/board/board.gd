extends Node3D

@onready var fruit_scene = preload("res://assets/fruits/fruit.tscn")

var meshes = MeshesConst.ITEM_MESHES

func _ready() -> void:
	spawn_fruits()

var pressedObject: Node3D = null

func spawn_fruits():
	var board_properties = get_board_positions()
	var board_positions = board_properties['positions']
	var item_size = board_properties['item_size']

	for i in range(board_positions.size()):
		var row = board_positions[i]
		for j in range(row.size()):
			var cell = row[j]
			var mesh_idx = randi() % meshes.size()
			var fruit = fruit_scene.instantiate()
			fruit.global_position = cell
			fruit.mesh_resource = load(meshes[mesh_idx])

			add_child(fruit)

func get_board_positions():
	var board_state = GameManager.get_board_state()
	var grid_width = board_state.grid_width
	var grid_height = board_state.grid_height
	var gap_percentage = board_state.gap_percentage

	var board_size = get_board_size()
	var item_size = get_item_size()
	
	var gap_x = (board_size.x * gap_percentage)
	var gap_z = (board_size.z * gap_percentage)

	var start_x = -board_size.x / 2 + item_size.x / 2 + gap_x / 2
	var start_z = -board_size.z / 2 + item_size.z / 2 + gap_z / 2

	var positions = []
	for row in range(grid_width):
		positions.append([])
		for cell in range(grid_height):
			var x = start_x + row * (item_size.x + gap_x)
			var y = 1
			var z = start_z + cell * (item_size.z + gap_z)
			
			var position = Vector3(x,y,z)
			positions[row].append(position) 
	
	return {
		'positions': positions,
		'item_size': item_size
	}

func get_item_size():
	var board_state = GameManager.get_board_state()
	var grid_width = board_state.grid_width
	var grid_height = board_state.grid_height
	var gap_percentage = board_state.gap_percentage

	var board_size = get_board_size()

	var total_gap_x = (grid_width) * (board_size.x * gap_percentage)
	var total_gap_z = (grid_height) * (board_size.z * gap_percentage)
	
	var cell_width = (board_size.x - total_gap_x) / grid_width
	var cell_height = (board_size.z - total_gap_z) / grid_height

	return Vector3(cell_width, cell_width, cell_height)

func get_board_size() -> Vector3:
	var board_mesh = $BoardMesh
	var aabb: AABB = board_mesh.get_aabb()
	return aabb.size * board_mesh.scale
