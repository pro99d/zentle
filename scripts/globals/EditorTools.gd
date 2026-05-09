extends Node

enum TOOLS{
	PEN,
	HAND,
	SELECT,
	LINE,
	SPACER,
	TEXT,
	REGION,
	ERASER,
	NONE
}

var toggle_shortcuts = {
	KEY_E: TOOLS.ERASER,
	KEY_S: TOOLS.SELECT,
	KEY_H: TOOLS.HAND,
	KEY_Q: TOOLS.PEN,
	KEY_T: TOOLS.TEXT,
}

var current_tool: TOOLS = TOOLS.PEN
var saved_tool: TOOLS = TOOLS.NONE

func _ready():
	EditorFuncs.connect("user_color_changed", func(col): update_cursor())
	EditorOptions.connect("theme_changed", func(col): update_cursor())
	
	EditorData.current_color = EditorColors.color_palette[0]
	update_cursor()

func is_current(_tool: TOOLS):
	return current_tool == _tool
	
var is_hold = false
func toggle_to(_tool: TOOLS, active: bool):
	if !active:
		if is_hold:
			set_tool(saved_tool)
		saved_tool = TOOLS.NONE
	elif !is_current(_tool):
		is_hold = false
		get_tree().create_timer(0.2).connect("timeout", func(): is_hold = true)
		saved_tool = current_tool
		set_tool(_tool)
	
func update_cursor():
	var img = Image.create(4, 4, false, Image.FORMAT_RGB8)
	
	match current_tool:
		TOOLS.ERASER:
			img = Image.create(EditorData.curr_eraser_size, EditorData.curr_eraser_size, false, Image.FORMAT_RGB8)
			img.fill(Color.WHITE)
		TOOLS.PEN:
			img.fill(EditorData.current_color)
		TOOLS.SELECT:
			img = Image.load_from_file("res://sprites/icons/select_cursor.png")
			img.resize(32, 32)
		TOOLS.TEXT:
			img = Image.load_from_file("res://sprites/icons/text_cursor.png")
			var overlay = Image.create_empty(img.get_width(), img.get_height(), false, img.get_format())
			overlay.fill(EditorData.current_color)
			img.blit_rect_mask(overlay, img, Rect2i(Vector2.ZERO, overlay.get_size()), Vector2.ZERO)
		TOOLS.HAND:
			img = Image.load_from_file("res://sprites/icons/hand_cursor.png")
			img.resize(32, 32)
			
	
	Input.set_custom_mouse_cursor(img, Input.CURSOR_ARROW, img.get_size() / 2)
		
func set_tool(_tool: TOOLS):
	if _tool == current_tool || _tool == TOOLS.NONE: 
		return
	current_tool = _tool
	update_cursor()
	
	if current_tool != TOOLS.SELECT:
		EditorFuncs.selection_manager.clear_selection_status()
	
func delete():
	var sel = EditorFuncs.selection_manager.selection_made
	if sel && sel.objs.size() > 0:
		EditorHistory.create_action("delete_selection", EditorFuncs.canvas_manager.remove_objs.bind(sel.objs.duplicate()), EditorFuncs.canvas_manager.add_objs.bind(sel.objs.duplicate()))
	
	EditorFuncs.selection_manager.clear_selection_status()
