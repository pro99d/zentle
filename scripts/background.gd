extends Node2D

func setup_background():
	RenderingServer.set_default_clear_color(EditorColors.background_col)
	setup_grid_shader()

func setup_grid_shader():
	var mat = back_rect.material
	mat.set_shader_parameter("grid_weight", EditorOptions.options[EditorOptions.OPTIONS.GRID_WEIGHT])
	mat.set_shader_parameter("background_col", EditorColors.background_col)
	mat.set_shader_parameter("grid_col", EditorColors.grid_col)
	mat.set_shader_parameter("square_size", EditorOptions.options[EditorOptions.OPTIONS.SQ_SIZE])

func _ready():
	EditorOptions.connect("theme_changed", func(old_palette): setup_background())
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
