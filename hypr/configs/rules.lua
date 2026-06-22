-- -----------------------------------------------------
-- Window Rules
-- -----------------------------------------------------

local function wrule(rule, match)
    local t = { name = "rule-" .. tostring(math.random(1000000)), match = match }
    if rule == "float on" then
        t.float = true
    elseif rule == "center on" then
        t.center = true
    elseif rule == "fullscreen on" then
        t.fullscreen = true
    elseif rule == "pin on" then
        t.pin = true
    elseif rule == "no_shadow on" then
        t.no_shadow = true
    elseif rule == "no_blur on" then
        t.no_blur = true
    elseif rule == "no_anim on" then
        t.no_anim = true
    elseif rule == "no_initial_focus on" then
        t.no_initial_focus = true
    elseif rule == "border_size 0" then
        t.border_size = 0
    elseif rule:match("^opacity (.*)") then
        t.opacity = rule:match("^opacity (.*)")
    elseif rule:match("^size (.*)") then
        t.size = rule:match("^size (.*)")
    elseif rule:match("^move (.*)") then
        t.move = rule:match("^move (.*)")
    elseif rule:match("^max_size (.*)") then
        t.max_size = rule:match("^max_size (.*)")
    elseif rule:match("^tag (.*)") then
        t.tag = rule:match("^tag (.*)")
    elseif rule:match("^animation (.*)") then
        t.animation = rule:match("^animation (.*)")
    end
    hl.window_rule(t)
end

wrule("float on", { class = "org.kde.polkit-kde-authentication-agent-1" })
wrule("float on", { class = "nm-connection-editor|blueman-manager" })
wrule("float on", { class = "pavucontrol" })
wrule("float on", { class = "nwg-look|qt5ct|mpv" })
wrule("float on", { class = "onedriver|onedriver-launcher" })
wrule("float on", { class = "eog" })
wrule("float on", { class = "zoom" })
wrule("float on", { class = "rofi" })
wrule("float on", { class = "gnome-system-monitor" })
wrule("float on", { class = "yad" })
wrule("float on", { class = "albert" })
wrule("float on", { class = "vicinae" })
wrule("float on", { class = "hyprland-share-picker" })
wrule("float on", { title = "(Rename.*)$" })
wrule("float on", { class = "PacketTracer" })
wrule("float on", { initial_title = "(Open Files)" })

wrule("float on", { class = "^(google-chrome)$" })
wrule("size (monitor_w*0.7) (monitor_h*0.8)", { class = "^(google-chrome)$" })
wrule("center on", { class = "^(google-chrome)$" })
wrule("opacity 0.95 0.95", { class = "^(google-chrome)$" })
wrule("opacity 0.95 0.95", { class = "^(google-chrome-stable)$" })

wrule("float on", { class = "^(firefox)$" })
wrule("size (monitor_w*0.7) (monitor_h*0.8)", { class = "^(firefox)$" })
wrule("center on", { class = "^(firefox)$" })
wrule("opacity 0.85 0.85", { class = "^(firefox)$" })
wrule("opacity 0.85 0.85", { class = "^(Firefox-esr)$" })

wrule("float on", { class = "^(zen)$" })
wrule("size (monitor_w*0.7) (monitor_h*0.8)", { class = "^(zen)$" })
wrule("center on", { class = "^(zen)$" })
wrule("opacity 0.95 1", { class = "^(zen)$" })

wrule("size (monitor_w*0.7) (monitor_h*0.8)", { class = "^(Code - Insiders)$" })
wrule("center on", { class = "^(Code - Insiders)$" })
wrule("opacity 0.90 0.90", { class = "^(Code - Insiders)$" })

wrule("size (monitor_w*0.7) (monitor_h*0.8)", { class = "^(code-insiders)$" })
wrule("center on", { class = "^(code-insiders)$" })
wrule("opacity 0.90 0.90", { class = "^(code-insiders)$" })

wrule("opacity 0.90 0.90", { class = "^(Code)$" })
wrule("opacity 0.90 0.90", { class = "^(code-url-handler)$" })

wrule("size (monitor_w*0.7) (monitor_h*0.8)", { class = "^(dev.zed.Zed)$" })
wrule("center on", { class = "^(dev.zed.Zed)$" })

wrule("float on", { class = "^(xdg-desktop-portal-gtk)$" })
wrule("size (monitor_w*0.6) (monitor_h*0.65)", { class = "^(xdg-desktop-portal-gtk)$" })
wrule("center on", { class = "^(xdg-desktop-portal-gtk)$" })

wrule("center on", { class = "pavucontrol" })
wrule("size (monitor_w*0.35) (monitor_h*0.4)", { class = "pavucontrol" })

wrule("float on", { class = "Calculator" })
wrule("float on", { class = "org.gnome.Calculator" })
wrule("size (monitor_w*0.1) (monitor_h*0.1)", { class = "^(org.gnome.Calculator)$" })
wrule("center on", { class = "^(org.gnome.Calculator)$" })

wrule("tag +games", { class = "^(steam_app_\\d+)$" })
wrule("fullscreen on", { tag = "games*" })

wrule("opacity 0.9 0.6", { class = "^([Rr]ofi)$" })
wrule("opacity 0.9 0.9", { class = "^(obsidian)$" })
wrule("opacity 0.9 0.8", { class = "^([Tt]hunar)$" })
wrule("opacity 0.8 0.6", { class = "^(pcmanfm-qt)$" })
wrule("opacity 0.9 0.7", { class = "^(gedit)$" })
wrule("opacity 0.9 0.8", { class = "^(kitty)$" })
wrule("opacity 0.9 0.7", { class = "^(mousepad)$" })
wrule("opacity 0.9 0.7", { class = "^(codium-url-handler)$" })
wrule("opacity 0.9 0.7", { class = "^(VSCodium)$" })
wrule("opacity 0.85 0.85", { class = "^(Spotify)$" })
wrule("opacity 0.85 0.85", { class = "^(spotify)$" })
wrule("opacity 0.80 0.80", { class = "^(chromium-browser)$" })
wrule("opacity 0.9 0.7", { class = "^(yad)$" })
wrule("opacity 0.9 0.7", { class = "^(com.obsproject.Studio)$" })
wrule("opacity 0.9 0.7", { class = "^([Aa]udacious)$" })
wrule("opacity 0.85 0.85", { class = "^(discord)$" })
wrule("opacity 0.85 0.85", { class = "^(WebCord)$" })
wrule("opacity 0.90 0.90", { class = "^(org.pwmt.zathura)$" })
wrule("opacity 0.90 0.90", { class = "^(zathura-cb)$" })
wrule("opacity 0.90 0.90", { class = "^(zathura-pdf-mupdf)$" })
wrule("opacity 0.95 0.95", { class = "^(Notion)$" })
wrule("opacity 0.95 0.95", { class = "^([Tt]odoist)$" })
wrule("opacity 0.85 0.85", { class = "^([Vv]esktop)$" })
wrule("opacity 0.85 0.85", { class = "^([Ss]herlock)$" })

wrule("border_size 0", { class = "^([Aa]lbert)$" })
wrule("animation popin", { class = "^([Aa]lbert)$" })
wrule("no_shadow on", { class = "^([Aa]lbert)$" })
wrule("no_blur on", { class = "^([Aa]lbert)$" })

wrule("opacity 1.0 override", { title = "^(Picture-in-Picture)$" })
wrule("pin on", { title = "^(Picture-in-Picture)$" })
wrule("float on", { title = "^(Picture-in-Picture)$" })
wrule("size (monitor_w*0.25) (monitor_h*0.25)", { title = "^(Picture-in-Picture)$" })
wrule("move (monitor_w*0.72) (monitor_h*0.70)", { title = "^(Picture-in-Picture)$" })

wrule("opacity 1.0 override", { title = "^(Picture in picture)$" })
wrule("pin on", { title = "^(Picture in picture)$" })
wrule("float on", { title = "^(Picture in picture)$" })
wrule("size (monitor_w*0.25) (monitor_h*0.25)", { title = "^(Picture in picture)$" })
wrule("move (monitor_w*0.72) (monitor_h*0.70)", { title = "^(Picture in picture)$" })

wrule("opacity 0.0 override", { class = "^(xwaylandvideobridge)$" })
wrule("no_anim on", { class = "^(xwaylandvideobridge)$" })
wrule("no_initial_focus on", { class = "^(xwaylandvideobridge)$" })
wrule("max_size 1 1", { class = "^(xwaylandvideobridge)$" })
wrule("no_blur on", { class = "^(xwaylandvideobridge)$" })

hl.layer_rule({
    match = { namespace = "vicinae" },
    blur = true,
    ignore_alpha = 0.2
})

hl.layer_rule({
    match = { namespace = "^noctalia-.*" },
    blur = true,
    ignore_alpha = 0.2
})

hl.config({
    layerrule = {
        "no_anim on, namespace:selection",
        "ignore_alpha 0.5, namespace:chromium-browser",
        "ignorezero, vicinae",
        "ignorealpha 0.5, vicinae",
        "noanim, vicinae"
    }
})
