local colors = {}
local f = io.open(os.getenv("HOME") .. "/.config/hypr/wallust/wallust-hyprland.conf", "r")
if f then
    for line in f:lines() do
        local key, val = line:match("%$(%w+)%s*=%s*(.+)")
        if key and val then
            colors[key] = val
        end
    end
    f:close()
end

-- Fallback to prevent errors if the file is missing
setmetatable(colors, {
    __index = function(_, key)
        return "rgb(000000)"
    end
})

return colors