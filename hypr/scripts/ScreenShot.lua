#!/usr/bin/env lua
-- Author: AceofStades
-- Github: github.com/AceofStades
-- Screenshots scripts

local home = os.getenv("HOME")
local iDIR = home .. "/.config/swaync/icons"
local sDIR = home .. "/.config/hypr/scripts"
local notify_cmd_shot = "notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i " ..
    iDIR .. "/picture.png"

local time = os.date("%d-%b_%H-%M-%S")
local xdg_dir_f = io.popen("xdg-user-dir")
local xdg_dir = xdg_dir_f:read("*l") or (home .. "/Pictures")
xdg_dir_f:close()
local dir = xdg_dir .. "/Pictures/Screenshots"
math.randomseed(os.time())
local file = string.format("Screenshot_%s_%d.png", time, math.random(10000, 99999))

local function exec_out(cmd)
    local f = io.popen(cmd)
    local out = f:read("*a")
    f:close()
    return out:gsub("\n$", "")
end

local active_window_class = exec_out("hyprctl -j activewindow | jq -r '.class'")
local active_window_file = string.format("Screenshot_%s_%s.png", time, active_window_class)
local active_window_path = dir .. "/" .. active_window_file

local function notify_view(mode)
    if mode == "active" then
        local f = io.open(active_window_path, "r")
        if f then
            f:close()
            os.execute(notify_cmd_shot .. " \"Screenshot of '" .. active_window_class .. "' Saved.\"")
            os.execute(sDIR .. "/Sounds.sh --screenshot")
        else
            os.execute(notify_cmd_shot .. " \"Screenshot of '" .. active_window_class .. "' not Saved\"")
        end
    elseif mode == "swappy" then
        os.execute(notify_cmd_shot .. " \"Screenshot Captured.\"")
    else
        local check_file = dir .. "/" .. file
        local f = io.open(check_file, "r")
        if f then
            f:close()
            os.execute(notify_cmd_shot .. " \"Screenshot Saved.\"")
            os.execute(sDIR .. "/Sounds.sh --screenshot")
        else
            os.execute(notify_cmd_shot .. " \"Screenshot NOT Saved.\"")
        end
    end
end

local function countdown(sec)
    for i = sec, 1, -1 do
        os.execute(string.format(
            "notify-send -h string:x-canonical-private-synchronous:shot-notify -t 1000 -i '%s/timer.png' 'Taking shot in : %d'",
            iDIR, i))
        os.execute("sleep 1")
    end
end

local function shotnow()
    os.execute(string.format('cd "%s" && grim - | tee "%s" | wl-copy', dir, file))
    os.execute("sleep 2")
    notify_view()
end

local function shot5()
    countdown(5)
    os.execute("sleep 1")
    os.execute(string.format('cd "%s" && grim - | tee "%s" | wl-copy', dir, file))
    os.execute("sleep 1")
    notify_view()
end

local function shot10()
    countdown(10)
    os.execute("sleep 1")
    os.execute(string.format('cd "%s" && grim - | tee "%s" | wl-copy', dir, file))
    notify_view()
end

local function shotwin()
    local w_pos = exec_out("hyprctl activewindow | grep 'at:' | cut -d':' -f2 | tr -d ' ' | tail -n1")
    local w_size = exec_out("hyprctl activewindow | grep 'size:' | cut -d':' -f2 | tr -d ' ' | tail -n1 | sed s/,/x/g")
    os.execute(string.format('cd "%s" && grim -g "%s %s" - | tee "%s" | wl-copy', dir, w_pos, w_size, file))
    notify_view()
end

local function shotarea()
    local tmpfile = os.tmpname()
    os.execute(string.format('grim -g "$(slurp)" - > "%s"', tmpfile))
    local f = io.open(tmpfile, "rb")
    if f then
        local content = f:read("*a")
        f:close()
        if #content > 0 then
            os.execute(string.format('wl-copy < "%s"', tmpfile))
            os.execute(string.format('mv "%s" "%s/%s"', tmpfile, dir, file))
        end
    end
    os.remove(tmpfile)
    notify_view()
end

local function shotactive()
    active_window_class = exec_out("hyprctl -j activewindow | jq -r '.class'")
    active_window_file = string.format("Screenshot_%s_%s.png", time, active_window_class)
    active_window_path = dir .. "/" .. active_window_file

    local geo = exec_out("hyprctl -j activewindow | jq -r '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"'")
    os.execute(string.format('grim -g "%s" "%s"', geo, active_window_path))
    os.execute("sleep 1")
    notify_view("active")
end

local function shotswappy()
    local tmpfile = os.tmpname()
    local cmd = string.format('grim -g "$(slurp)" - > "%s" && "%s/Sounds.sh" --screenshot', tmpfile, sDIR)
    local ret = os.execute(cmd)
    if ret == true or ret == 0 then
        notify_view("swappy")
    end
    os.execute(string.format('swappy -f "%s" -o "%s/%s"', tmpfile, dir, file))
    os.remove(tmpfile)
end

os.execute(string.format('mkdir -p "%s"', dir))

local arg1 = arg[1]
if arg1 == "--now" then
    shotnow()
elseif arg1 == "--in5" then
    shot5()
elseif arg1 == "--in10" then
    shot10()
elseif arg1 == "--win" then
    shotwin()
elseif arg1 == "--area" then
    shotarea()
elseif arg1 == "--active" then
    shotactive()
elseif arg1 == "--swappy" then
    shotswappy()
else
    print("Available Options : --now --in5 --in10 --win --area --active --swappy")
end

os.exit(0)
