#!/usr/bin/env lua
-- Author: AceofStades
-- Github: github.com/AceofStades

local instance_sig = os.getenv("HYPRLAND_INSTANCE_SIGNATURE")
if not instance_sig then os.exit(1) end
local socket_path = "/tmp/hypr/" .. instance_sig .. "/.socket2.sock"
local command = "socat -U - UNIX-CONNECT:" .. socket_path

local handle = io.popen(command)
if not handle then return end

for line in handle:lines() do
    if line:sub(1, 14) == "monitorremoved" then
        local lid_handle = io.popen(
        "grep -iq closed /proc/acpi/button/lid/*/state 2>/dev/null && echo 'closed' || echo 'open'")
        local lid_state = lid_handle:read("*a"):gsub("%s+", "")
        lid_handle:close()

        if lid_state == "closed" then
            local mon_handle = io.popen("hyprctl monitors -j | jq length")
            local num_monitors_str = mon_handle:read("*a"):gsub("%s+", "")
            mon_handle:close()
            local num_monitors = tonumber(num_monitors_str)

            if num_monitors == 0 then
                os.execute("systemctl suspend")
            end
        end
    end
end
handle:close()
