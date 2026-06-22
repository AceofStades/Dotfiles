-- -----------------------------------------------------
-- Core Settings
-- -----------------------------------------------------

local colors = require("configs.colors")

hl.config({
    workspace = {
        "6, monitor:HDMI-A-1",
        "7, monitor:HDMI-A-1",
        "8, monitor:HDMI-A-1",
        "9, monitor:HDMI-A-1",
        "10, monitor:eDP-1",
        "1, monitor:eDP-1",
        "2, monitor:eDP-1",
        "3, monitor:eDP-1",
        "4, monitor:eDP-1",
        "5, monitor:eDP-1"
    },
    dwindle = {
        preserve_split = true,
        special_scale_factor = 0.8,
    },
    master = {
        new_on_top = true,
        mfact = 0.5,
    },
    general = {
        gaps_in = 4,
        gaps_out = { top = 3, right = 8, bottom = 8, left = 8 },
        border_size = 1,
        resize_on_border = true,
        col = {
            active_border = { colors = { colors.color0, colors.color2, colors.color9, colors.color12, colors.color15 }, angle = 90 },
            inactive_border = colors.background,
        },
        layout = "master",
    },
    group = {
        col = {
            border_active = colors.color15,
        },
        groupbar = {
            col = {
                active = colors.color0,
            }
        }
    },
    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 0.9,
        fullscreen_opacity = 1.0,
        dim_inactive = true,
        dim_strength = 0.1,
        dim_special = 0.8,
        shadow = {
            enabled = false,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            ignore_opacity = true,
            new_optimizations = true,
            special = true,
        }
    },
    animations = {
        enabled = true
    },
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        repeat_rate = 50,
        repeat_delay = 300,
        numlock_by_default = true,
        left_handed = false,
        follow_mouse = 1,
        float_switch_override_focus = 0,
        sensitivity = 0.20,
        accel_profile = "adaptive",
        touchpad = {
            disable_while_typing = true,
            natural_scroll = true,
            clickfinger_behavior = false,
            middle_button_emulation = true,
            tap_to_click = true,
            drag_lock = false,
            scroll_factor = 0.2,
        }
    },
    gestures = {
        workspace_swipe_distance = 400,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_cancel_ratio = 0.5,
        workspace_swipe_create_new = true,
        workspace_swipe_forever = true,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
        enable_swallow = true,
        focus_on_activate = false,
        swallow_regex = "^(kitty)$",
    },
    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
    },
    xwayland = {
        force_zero_scaling = true,
    },
    cursor = {
        no_hardware_cursors = false,
        enable_hyprcursor = true,
    }
})

-- Animations
hl.curve("extreme", { type = "bezier", points = { { 0.4, 0.0 }, { 0.3, 1.0 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 2.8, bezier = "extreme", style = "popin 87%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.8, bezier = "extreme", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.2, bezier = "extreme", style = "popin 87%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2.8, bezier = "extreme", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "liner" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.5, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.2, bezier = "extreme", style = "slide" })
hl.animation({ leaf = "layersIn", enabled = false })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "extreme", style = "fade" })
