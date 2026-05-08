extends Node

var curr_path: String = ""
var file_dialog: FileDialog
var confirm_dialog: ConfirmationDialog
var file_label: Label
var animations: AnimationPlayer

const CURR_FS_VERSION = 2

var need_to_save = false

var serializers: Dictionary[int, CanvasSerializer] = {
	1: preload("res://scripts/serializers/v1.gd").new(1),
	2: preload("res://scripts/serializers/v2.gd").new(2)
}

func check_save_status(is_synced: bool):
	if is_synced:
		set_to_saved()
	else:
		set_to_unsaved()

func set_to_unsaved():
	if need_to_save: return
	need_to_save = true
	file_label.text += "*"
	
func set_to_saved():
	if !need_to_save: return
	need_to_save = false
	file_label.text = file_label.text.rstrip("*")
	
func set_file_dialog(_file_dialog: FileDialog):
	file_dialog = _file_dialog
	file_dialog.connect("file_selected", on_dialog_file_selected)

var confirm_dialog_callback: Callable
func set_confirm_dialog(_confirm_dialog: ConfirmationDialog):
	confirm_dialog = _confirm_dialog
	confirm_dialog.get_cancel_button().connect("pressed", func(): 
		need_to_save = false
		if !confirm_dialog_callback.is_null():
			confirm_dialog_callback.call()
			confirm_dialog_callback = Callable()
	)
	confirm_dialog.connect("confirmed", begin_save_file)

func show_confirm_dialog(callback: Callable):
	if need_to_save:
		confirm_dialog.visible = true
		confirm_dialog_callback = callback
	else:
		callback.call()
		
func set_file_label(label: Label):
	file_label = label

func set_animation_player(anim: AnimationPlayer):
	animations = anim

func begin_save_file():
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	
	if curr_path:
		end_save_to_path(curr_path)
	else:
		file_dialog.visible = true
		
func begin_open_file():
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.visible = true
	
func end_save_to_path(path: String):
	var serialized_data = serializers[CURR_FS_VERSION].serialize_canvas()
	if serialized_data["content"].size() == 0: return
	
	var f = FileAccess.open(path, FileAccess.WRITE)
	if !f: return
	
	var success = f.store_var(serialized_data, true)
	f.close()
	
	if success:
		set_to_saved()
		EditorHistory.mark_save_point()
		animations.play("save_label_animation")
		if !confirm_dialog_callback.is_null():
			confirm_dialog_callback.call()
			confirm_dialog_callback = Callable()
	
func end_open_path(path: String):
	var f = FileAccess.open(path, FileAccess.READ)
	if !f: return
	var data = f.get_var(true)
	f.close()
	
	if !data: return
	
	var fs_version = data.get("version", null)
	if !fs_version: return
	
	var seriaizer: CanvasSerializer = serializers.get(fs_version if fs_version is int else 1)
	if !seriaizer: return
	
	EditorFuncs.reset()
	
	var objs = seriaizer.deserialize_canvas(data)
	EditorFuncs.canvas_manager.add_objs(objs)
	
	set_to_saved()
	set_current_path(path)
	
func on_dialog_file_selected(path):
	file_dialog.visible = false
	
	match file_dialog.file_mode:
		FileDialog.FILE_MODE_SAVE_FILE:
			end_save_to_path(path)
		FileDialog.FILE_MODE_OPEN_FILE:
			end_open_path(path)
			
func set_current_path(path: String):
	curr_path = path
	var label_text = "new file"
	if curr_path:
		var file_name = path.get_file()
		var dir_name = path.get_base_dir().get_file()	
		label_text = dir_name + "/" + file_name
		
	file_label.text = label_text
	
