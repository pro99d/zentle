extends Node

var color_palette = [
	Color("#c9c1b1"), #light
	Color("#EB9486"), #orange
	Color("cc506bff"), #red
	Color("#B8B8F3"), #purple
	Color("#2274A5"), #
	Color("65b085ff"),
]

var background_col: Color = Color("#212121")
var grid_col: Color = Color("#2C2C2C")

enum UI {
	TEXT_MAIN, TEXT_DARK, TEXT_LIGHT,
	BG_DARK, BG_PANEL,
	PRIMARY, PRIMARY_HOVER, PRIMARY_PRESSED, PRIMARY_TRANSPARENT,
	ACCENT, SUCCESS, SUCCESS_BG
}

var ui_palette = {
	
}

var color_names = [
	"main_text",
	"critical",
	"important",
	"quote",
	"meta",
	"success"
]

var current_theme = "theme"

func _ready():
	calc_ui_color_palette()

func calc_ui_color_palette():
	var base_txt = color_palette[0]
	var primary = color_palette[3]
	var success = color_palette[5]

	# Popoliamo il dizionario usando le chiavi dell'Enum
	ui_palette[UI.TEXT_MAIN] = base_txt
	ui_palette[UI.TEXT_DARK] = base_txt.darkened(0.4)
	ui_palette[UI.TEXT_LIGHT] = base_txt.lightened(0.3)
	
	ui_palette[UI.BG_DARK] = base_txt.darkened(0.85)
	ui_palette[UI.BG_PANEL] = base_txt.darkened(0.7)
	
	ui_palette[UI.PRIMARY] = primary
	ui_palette[UI.PRIMARY_HOVER] = primary.lightened(0.15)
	ui_palette[UI.PRIMARY_PRESSED] = primary.darkened(0.15)
	ui_palette[UI.PRIMARY_TRANSPARENT] = Color(primary.r, primary.g, primary.b, 0.2)
	
	ui_palette[UI.ACCENT] = color_palette[4]
	
	ui_palette[UI.SUCCESS] = success
	ui_palette[UI.SUCCESS_BG] = success.darkened(0.6)

func get_color_index(color: Color) -> int:
	return color_palette.find(color)
