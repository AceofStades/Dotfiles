#!/usr/bin/env lua
-- Author: AceofStades
-- Github: github.com/AceofStades

local function random_hex()
    local handle = io.popen("openssl rand -hex 3")
    local hex = handle:read("*a"):gsub("%s+", "")
    handle:close()
    return "0xff" .. hex
end

local function generate_colors(count)
    local colors = {}
    for i = 1, count do
        table.insert(colors, random_hex())
    end
    return table.concat(colors, " ")
end

local active_colors = generate_colors(10)
os.execute("hyprctl keyword general:col.active_border " .. active_colors .. " 270deg")

local inactive_colors = generate_colors(10)
os.execute("hyprctl keyword general:col.inactive_border " .. inactive_colors .. " 270deg")
