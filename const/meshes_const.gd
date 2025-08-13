extends Node

const CUBE = "res://resources/cube.tres"
const CYLINDER = "res://resources/cylinder.tres"
const SPHERE = "res://resources/sphere.tres"

@export var ITEM_MESHES = [CUBE,CYLINDER,SPHERE]

@export var DEFAULT_ITEM_COLOR: Color = Color.html('#e2e2e2')
@export var ACTIVE_ITEM_COLOR: Color = Color.LIGHT_BLUE
