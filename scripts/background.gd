extends Node2D

var GRID_COL = Color("2C2C2C")
var GRID_WEIGHT = 2
var BACK_COL = Color("#212121")
var SQUARE_SIZE = 100

func _ready():
	SQUARE_SIZE = EditorOptions.sq_size
	
	RenderingServer.set_default_clear_color(BACK_COL)
	var mat = back_rect.material
	
	mat.set_shader_parameter("grid_weight", GRID_WEIGHT)
	mat.set_shader_parameter("background_col", BACK_COL)
	mat.set_shader_parameter("grid_col", GRID_COL)
	mat.set_shader_parameter("square_size", SQUARE_SIZE)
	
	
	call_deferred("update_material_position", Vector2.ZERO)
	call_deferred("update_material_zoom", 1)

@export var back_rect : ColorRect
func update_material_position(pos):
	var mat = back_rect.material
	mat.set_shader_parameter("viewport_size", get_viewport_rect().size)
	mat.set_shader_parameter("camera_position", pos)
func update_material_zoom(zoom):
	var mat = back_rect.material
	mat.set_shader_parameter("viewport_size", get_viewport_rect().size)
	mat.set_shader_parameter("camera_zoom", zoom)
