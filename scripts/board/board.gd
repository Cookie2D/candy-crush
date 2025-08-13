extends Node3D

@onready var fruit_scene = preload("res://assets/fruits/fruit.tscn")
@export var DEFAULT_COLOR = Color.html('#e2e2e2')
@export var ACTIVE_COLOR = Color.LIGHT_BLUE

var meshes = MeshesConst.ITEM_MESHES

func _ready() -> void:
	GameManager.fruit_click.connect(handle_fruit_click)
	fruit_scene
	spawn_fruits()

var pressedObject: Node3D = null
func handle_fruit_click(fruit: Node3D) -> void:
	if not pressedObject: # no pressed object
		pressedObject = fruit
		fruit.mesh_color = ACTIVE_COLOR
		return

	if pressedObject.get_instance_id() == fruit.get_instance_id(): # the same object
		fruit.mesh_color = DEFAULT_COLOR
		pressedObject = null
		return

	swap_objects(fruit, pressedObject)

	pressedObject.mesh_color = DEFAULT_COLOR
	pressedObject = null

func swap_objects(previous: Node3D, current: Node3D) -> void:
	var tween_new = create_tween()
	var tween_pressed = create_tween()

	var current_position = Vector3(current.position)
	var previous_position = Vector3(previous.position)
	current_position.y += 0.5
	previous_position.y -= 0.5

	tween_new.tween_property(current, "position", current_position, 0.2).set_delay(0)
	tween_pressed.tween_property(previous, "position", previous_position, 0.2).set_delay(0)

	var temp_y = previous_position.y
	previous_position.y = current_position.y
	current_position.y = temp_y

	tween_new.tween_property(current, "position", previous_position, 0.3).set_delay(0)
	tween_pressed.tween_property(previous, "position", current_position, 0.3).set_delay(0)

	current_position.y += 0.5
	previous_position.y -= 0.5
	
	tween_new.tween_property(current, "position", previous_position, 0.2).set_delay(0)
	tween_pressed.tween_property(previous, "position", current_position, 0.2).set_delay(0)

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

func get_board_positions(grid_width = 8, grid_height = 8, gap_percentage = 0.05):
	var board_size = get_board_size()
	var item_size = get_item_size(grid_width, grid_height, gap_percentage)
	
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

func get_item_size(grid_width = 8, grid_height = 8, gap_percentage = 0.05):
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
