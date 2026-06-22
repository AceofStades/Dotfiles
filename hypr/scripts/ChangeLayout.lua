#!/usr/bin/env lua
-- Author: AceofStades
-- Github: github.com/AceofStades
-- for changing Hyprland Layouts (Master, Dwindle, or Scrolling) on the fly
-- Also handles layout-aware resizing and scrolling via 'hyprctl dispatch' with Lua syntax

local notif_icon = os.getenv("HOME") .. "/.config/swaync/images/bell.png"

local function get_layout()
    local handle = io.popen("hyprctl -j getoption general:layout | jq -r '.str'")
    local res = handle:read("*a"):gsub("%s+", "")
    handle:close()
    return res
end

local function hypr_dispatch(code)
    os.execute(string.format("hyprctl dispatch %q", code))
end

local mode = arg[1]

-- 1. Resizing Logic
if mode == "--resize" then
    local dir = arg[2]
    local layout = get_layout()

    if layout == "master" then
        if dir == "h" then
            hypr_dispatch("hl.dsp.layout('mfact -0.05')")
        elseif dir == "l" then
            hypr_dispatch("hl.dsp.layout('mfact +0.05')")
        elseif dir == "k" then
            hypr_dispatch("hl.dsp.exec_raw('resizeactive', '0 -50')")
        elseif dir == "j" then
            hypr_dispatch("hl.dsp.exec_raw('resizeactive', '0 50')")
        end
    elseif layout == "dwindle" then
        if dir == "h" or dir == "k" then
            hypr_dispatch("hl.dsp.layout('splitratio -0.05')")
        else
            hypr_dispatch("hl.dsp.layout('splitratio +0.05')")
        end
    elseif layout == "scrolling" then
        if dir == "h" then
            hypr_dispatch("hl.dsp.layout('colresize -0.05')")
        elseif dir == "l" then
            hypr_dispatch("hl.dsp.layout('colresize +0.05')")
        elseif dir == "k" then
            hypr_dispatch("hl.dsp.exec_raw('resizeactive', '0 -50')")
        elseif dir == "j" then
            hypr_dispatch("hl.dsp.exec_raw('resizeactive', '0 50')")
        end
    end
    os.exit(0)

    -- 2. Scrolling Logic
elseif mode == "--scroll" then
    local dir = arg[2]
    local layout = get_layout()
    if layout == "scrolling" then
        local scroll_cmd = (dir == "next") and "move +col" or "move -col"
        hypr_dispatch(string.format("hl.dsp.layout(%q)", scroll_cmd))
    end
    os.exit(0)

    -- 3. Layout Switching Logic (Default / SUPER + Y)
else
    local current = get_layout()
    local target = ""

    if current == "master" then
        target = "dwindle"
    elseif current == "dwindle" then
        target = "scrolling"
    else
        target = "master"
    end

    -- Switch the layout
    os.execute(string.format("hyprctl eval \"hl.config({ general = { layout = '%s' } })\"", target))

    -- Notify the user
    os.execute(string.format("notify-send -a 'Hyprland' -u low -i '%s' '%s Layout' 'Layout Switched'", notif_icon,
        target:gsub("^%l", string.upper)))
    os.exit(0)
end
