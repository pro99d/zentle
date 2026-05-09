extends Node

signal theme_changed(old_palette)
signal config_loaded

var realtime_move_scale = true
var sq_size = 100
var grid_weight = 2
var current_theme = ""
var ctrl_to_zoom = false

var shape_snap_tolerance = 0.5		#0.5 half a square
var shape_snap_dist = 20      		#dist before snapping

func _ready():
	call_deferred("load_config_file")

var config: ConfigFile = ConfigFile.new()
var config_path = "user://settings.cfg"
func load_config_file():
	var err = config.load(config_path)
	if err != OK:
		save_default_settings()
		emit_signal("theme_changed", EditorColors.color_palette.duplicate())
		emit_signal("config_loaded")
		return
	
	sq_size = int(config.get_value("editor", "sq_size", sq_size))
	ctrl_to_zoom = bool(config.get_value("editor", "ctrl_to_zoom", ctrl_to_zoom))
	realtime_move_scale = bool(config.get_value("editor", "realtime_move_scale", realtime_move_scale))
	grid_weight = bool(config.get_value("editor", "grid_weight", grid_weight))
	
	load_themes_from_settings()
	
	var tmp_current_theme = config.get_value("editor", "current_theme", "theme_default")
	load_theme(tmp_current_theme)
	
	emit_signal("config_loaded")
	
	
var all_themes = {}
func load_themes_from_settings():
	for curr_theme_sec in config.get_sections():
		if curr_theme_sec.begins_with("theme"):
			var curr_theme_data = {
				"color_palette": []
			}
			for c in range(EditorColors.color_palette.size()):
				var key = EditorColors.color_names[c]
				curr_theme_data["color_palette"].append(Color(config.get_value(curr_theme_sec, key, EditorColors.color_palette[c])))
	
			curr_theme_data["background_col"] = Color(config.get_value(curr_theme_sec, "background_color", EditorColors.background_col))
			curr_theme_data["grid_col"] = Color(config.get_value(curr_theme_sec, "grid_color", EditorColors.grid_col))
			
			all_themes[curr_theme_sec] = curr_theme_data

func load_theme(theme: String):
	if !all_themes.has(theme):
		return
	
	if theme != current_theme:
		var old_palette = EditorColors.color_palette.duplicate()
		EditorColors.color_palette = all_themes[theme].get("color_palette", EditorColors.color_palette)
		EditorColors.background_col = all_themes[theme].get("background_col", EditorColors.background_col)
		EditorColors.grid_col = all_themes[theme].get("grid_col", EditorColors.grid_col)
		
		EditorColors.calc_ui_color_palette()
		EditorData.current_color = EditorColors.color_palette[0]
		
		current_theme = theme
		emit_signal("theme_changed", old_palette)
		config.set_value("editor", "current_theme", theme)
		config.save(config_path)
		
func save_default_settings():
	for c in range(EditorColors.color_palette.size()):
		var key = EditorColors.color_names[c]
		config.set_value("theme_default", key, "#" + EditorColors.color_palette[c].to_html())
	
	config.set_value("theme_default", "background_color", "#" + EditorColors.background_col.to_html())
	config.set_value("theme_default", "grid_color", "#" + EditorColors.grid_col.to_html())
	
	config.set_value("editor", "sq_size", sq_size)
	config.set_value("editor", "ctrl_to_zoom", ctrl_to_zoom)
	config.set_value("editor", "current_theme", "theme_default")
	config.set_value("editor", "realtime_move_scale", realtime_move_scale)
	config.set_value("editor", "grid_weight", grid_weight)
	
	config.save(config_path)
