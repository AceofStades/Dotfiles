-- -----------------------------------------------------
-- Environment Variables
-- -----------------------------------------------------

hl.env("CLUTTER_BACKEND", "wayland")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

local cursor_theme = (io.popen("gsettings get org.gnome.desktop.interface cursor-theme"):read("*a"):gsub("'", ""):gsub("\n", ""))
local cursor_size = (io.popen("gsettings get org.gnome.desktop.interface cursor-size"):read("*a"):gsub("\n", ""))
hl.env("XCURSOR_THEME", cursor_theme)
hl.env("XCURSOR_SIZE", cursor_size)

hl.env("MOZ_ENABLE_WAYLAND", "1")
