extends VBoxContainer


func _ready():
	EditorOptions.connect("config_loaded", func():
		for theme in EditorOptions.all_themes:
			var btn = Button.new()
			btn.text = theme.lstrip("theme_")
			btn.connect("pressed", func(): 
				EditorOptions.load_theme(theme)
				)
			add_child(btn)
		)
