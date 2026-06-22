-- -----------------------------------------------------
-- Keybinds
-- -----------------------------------------------------

local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"
local ipc = "qs -c noctalia-shell ipc call"
local term = "kitty"
local files = "thunar"

-- Setup binds
hl.config({
})

-- Vim-style resizing (Layout-aware via script)
hl.bind("SUPER + H", hl.dsp.exec_cmd(scriptsDir .. "/ChangeLayout.lua --resize h"), { repeating = true })
hl.bind("SUPER + L", hl.dsp.exec_cmd(scriptsDir .. "/ChangeLayout.lua --resize l"), { repeating = true })
hl.bind("SUPER + K", hl.dsp.exec_cmd(scriptsDir .. "/ChangeLayout.lua --resize k"), { repeating = true })
hl.bind("SUPER + J", hl.dsp.exec_cmd(scriptsDir .. "/ChangeLayout.lua --resize j"), { repeating = true })

-- Scrolling specific navigation
hl.bind("SUPER + period", hl.dsp.exec_cmd(scriptsDir .. "/ChangeLayout.lua --scroll next"))
hl.bind("SUPER + comma", hl.dsp.exec_cmd(scriptsDir .. "/ChangeLayout.lua --scroll prev"))


-- Keyboard Brightness
hl.bind("xf86KbdBrightnessDown", hl.dsp.exec_cmd(scriptsDir .. "/BrightnessKbd.lua --dec"), { repeating = true })
hl.bind("xf86KbdBrightnessUp", hl.dsp.exec_cmd(scriptsDir .. "/BrightnessKbd.lua --inc"), { repeating = true })

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -modi drun,filebrowser,run,window"),
    { release = true })

-- Audio & Media & Brightness (Locked/Repeating binds)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " volume increase"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. " volume decrease"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. " brightness decrease"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. " brightness increase"), { locked = true, repeating = true })

hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. " volume muteOutput"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(ipc .. " volume muteInput"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(ipc .. " media togglePlay"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ipc .. " media togglePlay"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(ipc .. " media stop"), { locked = true })
hl.bind("XF86PowerOff", hl.dsp.exec_cmd(ipc .. " sessionMenu toggle"), { locked = true })

hl.bind("switch:off:Lid Switch",
    hl.dsp.exec_cmd("hyprctl keyword monitor 'eDP-1, 2880x1800@60, 0x0, 1.5' && hyprctl dispatch dpms on"),
    { locked = true })
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })

-- -----------------------------------------------------
-- Normal Keybinds
-- -----------------------------------------------------
-- Window Management & System
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("hyprctl dispatch exit 0"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind("ALT + Return", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("SUPER + Y", hl.dsp.exec_cmd(scriptsDir .. "/ChangeLayout.lua"))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd(scriptsDir .. "/LockScreen.lua"))
hl.bind("CTRL + ALT + P", hl.dsp.exec_cmd(scriptsDir .. "/Wlogout.lua"))
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("killall qs; qs -c noctalia-shell"))
hl.bind("ALT + Tab", hl.dsp.exec_cmd("hyprctl dispatch 'hl.dsp.window.cycle_next()'"))

-- App Launchers
hl.bind("ALT + Space", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind("SUPER + Return", hl.dsp.exec_cmd(term))
hl.bind("SUPER + T", hl.dsp.exec_cmd(term))
hl.bind("SUPER + E", hl.dsp.exec_cmd(files))
hl.bind("SUPER + N", hl.dsp.exec_cmd("swaync-client -t -sw"))

-- Features / Extras
hl.bind("SUPER + SHIFT + H", hl.dsp.exec_cmd(scriptsDir .. "/Help.lua"))
hl.bind("SUPER + period", hl.dsp.exec_cmd("vicinae vicinae://launch/core/search-emojis"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(scriptsDir .. "/ChangeBlur.lua"))
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd(scriptsDir .. "/GameMode.lua"))
hl.bind("SUPER + ALT + K", hl.dsp.exec_cmd(scriptsDir .. "/SwitchKeyboardLayout.lua"))
hl.bind("SUPER + Z", hl.dsp.exec_cmd(scriptsDir .. "/ChangeLayout.lua"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"))
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd(scriptsDir .. "/ZshChangeTheme.lua"))
hl.bind("SUPER + R", hl.dsp.exec_cmd(scriptsDir .. "/QuickEdit.lua"))
hl.bind("SUPER + CTRL + S", hl.dsp.exec_cmd(scriptsDir .. "/RofiBeats.lua"))
hl.bind("SUPER + W", hl.dsp.exec_cmd(ipc .. " wallpaper toggle"))
hl.bind("CTRL + ALT + W", hl.dsp.exec_cmd(scriptsDir .. "/Wallpaper.lua awww"))

-- Waybar
hl.bind("SUPER + B", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd(scriptsDir .. "/WaybarStyles.lua"))
hl.bind("SUPER + ALT + W", hl.dsp.exec_cmd(scriptsDir .. "/WaybarLayout.lua"))

-- Layouts
hl.bind("SUPER + CTRL + D", hl.dsp.layout("removemaster"))
hl.bind("SUPER + I", hl.dsp.layout("addmaster"))
hl.bind("SUPER + CTRL + Return", hl.dsp.layout("cyclenext"))
hl.bind("SUPER + ALT + K", hl.dsp.layout("cycleprev"))
hl.bind("SUPER + ALT + P", hl.dsp.window.pseudo())
hl.bind("SUPER + Space", hl.dsp.layout("swapwithmaster"))

-- Groups
hl.bind("SUPER + G", hl.dsp.exec_raw("togglegroup", ""))
hl.bind("ALT + tab", hl.dsp.exec_raw("bringactivetotop", ""))

-- Laptop keys
hl.bind("SUPER + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.lua --now"))
hl.bind("SUPER + SHIFT + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.lua --area"))
hl.bind("SUPER + CTRL + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.lua --in5"))
hl.bind("SUPER + ALT + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.lua --in10"))
hl.bind("ALT + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.lua --active"))

-- Media
hl.bind("SUPER + S", hl.dsp.exec_cmd(ipc .. " media playPause"))
hl.bind("SUPER + D", hl.dsp.exec_cmd(ipc .. " media next"))
hl.bind("SUPER + A", hl.dsp.exec_cmd(ipc .. " media previous"))

-- Screenshot
hl.bind("SUPER + Print", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.lua --now"))
hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.lua --swappy"))
-- hl.bind("code:361", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.lua --swappy"))
hl.bind("SUPER + CTRL + Print", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.lua --in5"))
hl.bind("SUPER + ALT + Print", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.lua --in10"))
hl.bind("ALT + Print", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.lua --active"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("grim -g \"$(slurp -w 0)\" - | swappy -f -"))
hl.bind("xf86WebCam", hl.dsp.exec_cmd(scriptsDir .. "/WebCam.lua"))

-- Movement
hl.bind("SUPER + CTRL + left", hl.dsp.exec_cmd("hyprctl dispatch movewindow l"))
hl.bind("SUPER + CTRL + right", hl.dsp.exec_cmd("hyprctl dispatch movewindow r"))
hl.bind("SUPER + CTRL + up", hl.dsp.exec_cmd("hyprctl dispatch movewindow u"))
hl.bind("SUPER + CTRL + down", hl.dsp.exec_cmd("hyprctl dispatch movewindow d"))
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

-- Workspaces
hl.bind("SUPER + tab", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + SHIFT + U", hl.dsp.window.move({ workspace = "special" }))
hl.bind("SUPER + U", hl.dsp.workspace.toggle_special(""))

for i = 1, 9 do
    hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
    hl.bind("SUPER + CTRL + " .. i, hl.dsp.exec_raw("movetoworkspacesilent", tostring(i)))
end
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = "10" }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))
hl.bind("SUPER + CTRL + 0", hl.dsp.exec_raw("movetoworkspacesilent", "10"))

hl.bind("SUPER + SHIFT + bracketleft", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + CTRL + bracketleft", hl.dsp.exec_raw("movetoworkspacesilent", "-1"))
hl.bind("SUPER + CTRL + bracketright", hl.dsp.exec_raw("movetoworkspacesilent", "+1"))

hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + comma", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + M", hl.dsp.focus({ workspace = "e-1" }))
