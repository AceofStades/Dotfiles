-- -----------------------------------------------------
-- Auto Start System Services and Configuration
-- -----------------------------------------------------

local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"

hl.on("hyprland.start", function()
    local wallpaper = os.getenv("HOME") .. "/.config/hypr/wallpaper_effects/.wallpaper_modified"

    local f_wp = io.open(wallpaper, "r")
    if f_wp then
        f_wp:close()
        os.execute("wallust run -s " .. wallpaper .. " > /dev/null")
    end

    os.execute(scriptsDir .. "/SwitchKeyboardLayout.lua > /dev/null 2>&1 &")

    -- System level autostart
    hl.exec_cmd(
    "sh -c 'dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XCURSOR_THEME XCURSOR_SIZE && systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XCURSOR_THEME XCURSOR_SIZE && sleep 1 && systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal'")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    hl.exec_cmd("hyprctl setcursor macOS 22")

    hl.exec_cmd("source ~/.profile")
    hl.exec_cmd(scriptsDir .. "/MonitorHotplug.lua")

    -- Startup apps from user
    hl.exec_cmd("syncthing")
    hl.exec_cmd("qs -c noctalia-shell")
    hl.exec_cmd("vicinae server")
    hl.exec_cmd("hypridle")
    hl.exec_cmd(scriptsDir .. "/RainbowBorders.lua")
end)
