# Zentle

Zentle is a minimalist note-taking app focused on speed. \
Note: This project is in a very early WIP stage. If it doesn't break, it's probably a bug.

### Features
#### Tools (shortcut)

Pen (q)
  - draw and hold to begin shape recognition. If a shape is recognized it can then be modified

Hand (h) - for panning  \
Select (s)
  - press Ctrl while scaling and moving to snap to the grid
  - hold Ctrl while making a box selection to only select objects that are inside the box
    
Text (t)
  - surround the text with \__...\__ to underline, with \**...\**  to bold
  - insert inline LaTex expressions inside \$ ... \$ blocks

#### Themes
Press __Ctrl + Shift + t__ to open the theme selector. The listed themes are loaded from the config file.

#### Config File (settings.cfg)
- on linux: ~/.local/share/zentle/
- on windows: %APPDATA%\zentle\

Created when first opened
(e.g settings.cfg)
```
[theme_default]

main_text="#c9c1b1ff"
critical="#eb9486ff"
important="#cc506bff"
quote="#b8b8f3ff"
meta="#2274a5ff"
success="#65b085ff"
background_color="#212121ff"
grid_color="#2c2c2cff"

[editor]

sq_size=100
ctrl_to_zoom=false
current_theme="theme_default"
realtime_move_scale=true
grid_weight=2

```

To define a new theme, create a new section that begins with "theme_" (e.g \[theme_gruvbox\]) \
Each theme has 6 colors (main_text, critical, important, quote, meta, success) + the background and grid colors.

#### File saving
Files are currently saved in a binary format and cannot be exported
