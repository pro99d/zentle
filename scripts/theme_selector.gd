extends VBoxContainer

func _ready():
	EditorOptions.connect("config_loaded", func():
		for theme in EditorOptions.all_themes:
			var btn = Button.new()
			btn.text = theme.lstrip("theme").trim_prefix("_")
			btn.connect("pressed", func(): 
				EditorOptions.load_theme(theme)
				)
			add_child(btn)
		)

func _on_line_edit_text_changed(new_text):
	for btn in get_children():
		btn.visible = !new_text || btn.text.contains(new_text)

@export var line_edit : LineEdit
func on_visible():
	line_edit.grab_focus()
