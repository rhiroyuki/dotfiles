-- Hyprland Lua config.
--
-- Since Hyprland 0.55 hyprlang is deprecated in favour of Lua
-- (https://wiki.hypr.land/Configuring/Start/). Hyprland loads exactly one
-- config per startup, and this file is the only one this repo ships -- the
-- superseded hyprland.conf has been deleted (recoverable from git history if
-- the old syntax is ever needed).
--
-- Lua stubs for LSP autocompletion live in /usr/share/hypr/stubs.

local home = os.getenv("HOME")

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "2560x1440@120",
    position = "auto",
    scale    = 1,
})

--------------
---- MISC ----
--------------

-- Catppuccin Macchiato
local palette = {
    rosewater = "rgba(F4DBD6ff)",
    flamingo  = "rgba(F0C6C6ff)",
    pink      = "rgba(F5BDE6ff)",
    mauve     = "rgba(C6A0F6ff)",
    red       = "rgba(ED8796ff)",
    maroon    = "rgba(EE99A0ff)",
    peach     = "rgba(F5A97Fff)",
    green     = "rgba(A6DA95ff)",
    teal      = "rgba(8BD5CAff)",
    sky       = "rgba(91D7E3ff)",
    sapphire  = "rgba(7DC4E4ff)",
    blue      = "rgba(8AADF4ff)",
    lavender  = "rgba(B7BDF8ff)",
    text      = "rgba(CAD3F5ff)",
    subtext1  = "rgba(B8C0E0ff)",
    subtext0  = "rgba(A5ADCBff)",
    overlay2  = "rgba(939AB7ff)",
    overlay1  = "rgba(8087A2ff)",
    overlay0  = "rgba(6E738Dff)",
    surface2  = "rgba(5B6078ff)",
    surface1  = "rgba(494D64ff)",
    surface0  = "rgba(363A4Fff)",
    base      = "rgba(24273Aff)",
    mantle    = "rgba(1E2030ff)",
    crust     = "rgba(181926ff)",
}

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 0,
        border_size = 1,

        col = {
            active_border   = { colors = { palette.mauve, palette.lavender }, angle = 45 },
            inactive_border = palette.overlay0,
        },

        layout        = "dwindle",
        allow_tearing = false,
    },

    decoration = {
        rounding = 0,

        blur = {
            enabled = false,
        },

        shadow = {
            enabled = false,
        },
    },

    animations = {
        enabled = false,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    input = {
        kb_layout    = "us",
        kb_variant   = "intl",
        kb_options   = "ctrl:nocaps,lv3:ralt_alt",
        repeat_delay = 300,
        repeat_rate  = 30,
        follow_mouse = 1,

        touchpad = {
            natural_scroll       = false,
            tap_to_click         = true,
            disable_while_typing = true,
        },
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})

-------------------
---- AUTOSTART ----
-------------------

-- `uwsm app --` ensures apps run as proper systemd units.
hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -- hyprpaper")
    hl.exec_cmd("uwsm app -- hypridle")
    hl.exec_cmd("uwsm app -- nm-applet --indicator")
    hl.exec_cmd("uwsm app -- blueman-applet")
    hl.exec_cmd("uwsm app -- hyprsunset")
    hl.exec_cmd("uwsm app -- fcitx5 -d")
    hl.exec_cmd("uwsm app -- wl-paste --type text --watch cliphist store")
    hl.exec_cmd("uwsm app -- wl-paste --type image --watch cliphist store")
    hl.exec_cmd("uwsm app -- dunst")
    hl.exec_cmd(home .. "/dotfiles/bin/launch_waybar")
end)

---------------------
---- KEYBINDINGS ----
---------------------

-- ALT   = Alt (Mod1)
-- SUPER = Super/Windows key (Mod4)

-- Speech-to-text (handy)
hl.bind("SUPER + T", hl.dsp.exec_cmd([[bash -c 'handy --toggle-transcription; f=/tmp/handy_state; if [ -f "$f" ]; then rm "$f"; notify-send -t 1500 "Handy" "OFF"; else touch "$f"; notify-send -t 1500 "Handy" "ON"; fi']]),
    { description = "Speech-to-text (handy)" })

-- Lock screen
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"), { description = "Lock screen" })

---- Media / hardware keys ----

hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd([[pactl set-sink-volume @DEFAULT_SINK@ +10% && notify-send -t 1500 "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1)%"]]),
    { locked = true, repeating = true, description = "Volume up" })

hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd([[pactl set-sink-volume @DEFAULT_SINK@ -10% && notify-send -t 1500 "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1)%"]]),
    { locked = true, repeating = true, description = "Volume down" })

hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd([[pactl set-sink-mute @DEFAULT_SINK@ toggle && notify-send -t 1500 "Volume" "$(pactl get-sink-mute @DEFAULT_SINK@ | grep -q yes && echo Muted || echo Unmuted)"]]),
    { locked = true, description = "Toggle mute" })

hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd([[pactl set-source-mute @DEFAULT_SOURCE@ toggle && notify-send -t 1500 "Mic" "$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -q yes && echo Muted || echo Unmuted)"]]),
    { locked = true, description = "Toggle mic mute" })

-- Brightness is owned by bin/gamma, not brightnessctl: this box has
-- no /sys/class/backlight device.
hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd([[notify-send -t 1500 "Brightness" "$(]] .. home .. [[/dotfiles/bin/gamma nudge up)%"]]),
    { locked = true, repeating = true, description = "Brightness up" })

hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd([[notify-send -t 1500 "Brightness" "$(]] .. home .. [[/dotfiles/bin/gamma nudge down)%"]]),
    { locked = true, repeating = true, description = "Brightness down" })

hl.bind("XF86AudioPlay",
    hl.dsp.exec_cmd([[playerctl play-pause && notify-send -t 1500 "Media" "$(playerctl status): $(playerctl metadata title)"]]),
    { locked = true, description = "Play/pause media" })

hl.bind("XF86AudioPause",
    hl.dsp.exec_cmd([[playerctl pause && notify-send -t 1500 "Media" "Paused: $(playerctl metadata title)"]]),
    { locked = true, description = "Pause media" })

hl.bind("XF86AudioNext",
    hl.dsp.exec_cmd([[playerctl next && notify-send -t 1500 "Media" "Next: $(playerctl metadata title)"]]),
    { locked = true, description = "Next track" })

hl.bind("XF86AudioPrev",
    hl.dsp.exec_cmd([[playerctl previous && notify-send -t 1500 "Media" "Previous: $(playerctl metadata title)"]]),
    { locked = true, description = "Previous track" })

---- Launching ----

hl.bind("ALT + CTRL + T", hl.dsp.exec_cmd("ghostty"), { description = "Start a terminal" })
hl.bind("SUPER + E", hl.dsp.exec_cmd("nemo"), { description = "File explorer" })
hl.bind("SUPER + Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f -]]),
    { description = "Screenshot (region to clipboard)" })

hl.bind("ALT + Return", hl.dsp.exec_cmd(home .. "/dotfiles/bin/session-launcher"),
    { description = "Launcher" })
hl.bind("ALT + E", hl.dsp.exec_cmd("rofi -show emoji"), { description = "Emoji" })
hl.bind("SUPER + P", hl.dsp.exec_cmd(home .. "/dotfiles/bin/session-powermenu"),
    { description = "Powermenu (shutdown, suspend, reboot, log out)" })

hl.bind("ALT + CTRL + F",
    hl.dsp.exec_cmd([[cliphist list | rofi -dmenu -p "Clipboard" | cliphist decode | wl-copy]]),
    { description = "Clipboard history" })
hl.bind("ALT + SHIFT + slash", hl.dsp.exec_cmd(home .. "/dotfiles/bin/session-keybindings"),
    { description = "Show keybindings" })

---- Window management ----

hl.bind("ALT + SHIFT + Q", hl.dsp.window.close(), { description = "Kill focused window" })

-- Vim keys and arrow keys are bound identically. Descriptions are spelled out
-- because they are what the cheatsheet (bin/session-keybindings) displays.
local directions = {
    { keys = { "H", "left" },  dir = "l", name = "left" },
    { keys = { "J", "down" },  dir = "d", name = "down" },
    { keys = { "K", "up" },    dir = "u", name = "up" },
    { keys = { "L", "right" }, dir = "r", name = "right" },
}

for _, d in ipairs(directions) do
    for _, key in ipairs(d.keys) do
        hl.bind("ALT + " .. key, hl.dsp.focus({ direction = d.dir }),
            { description = "Focus " .. d.name })
        hl.bind("ALT + SHIFT + " .. key, hl.dsp.window.move({ direction = d.dir }),
            { description = "Move window " .. d.name })
    end
end

hl.bind("SUPER + H", hl.dsp.layout("preselect l"), { description = "Split horizontal" })
hl.bind("SUPER + V", hl.dsp.layout("preselect d"), { description = "Split vertical" })

hl.bind("ALT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
    { description = "Toggle fullscreen" })
hl.bind("ALT + T", hl.dsp.layout("togglesplit"), { description = "Layout: toggle split" })
hl.bind("ALT + SHIFT + space", hl.dsp.window.float({ action = "toggle" }),
    { description = "Toggle tiling / floating" })
hl.bind("ALT + SHIFT + F", hl.dsp.exec_cmd(home .. "/.config/hypr/bin/float-window"),
    { description = "Toggle a persistent float rule for the focused window's class" })
hl.bind("ALT + space", hl.dsp.window.cycle_next(),
    { description = "Change focus between tiling / floating windows" })

hl.bind("ALT + SHIFT + C",
    hl.dsp.exec_cmd([[hyprctl reload && notify-send "Hyprland" "Config reloaded"]]),
    { description = "Reload the configuration file" })
hl.bind("ALT + SHIFT + E", hl.dsp.exec_cmd("uwsm stop"), { description = "Exit hyprland" })

-- Mouse: drag and resize floating windows
hl.bind("ALT + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Drag window" })
hl.bind("ALT + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

---- Workspaces ----

for i = 1, 10 do
    local key = i % 10 -- workspace 10 lives on the 0 key
    hl.bind("ALT + " .. key, hl.dsp.focus({ workspace = i }),
        { description = "Switch to workspace " .. i })
    -- follow = false is the old `movetoworkspacesilent`
    hl.bind("ALT + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }),
        { description = "Move container to workspace " .. i })
end

hl.bind("ALT + SHIFT + Tab", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
hl.bind("ALT + Tab", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })

---- Resize submap ----

hl.bind("ALT + R", hl.dsp.submap("resize"), { description = "Enter resize mode" })

hl.define_submap("resize", function()
    for _, k in ipairs({ "H", "left" }) do
        hl.bind(k, hl.dsp.window.resize({ x = -30, y = 0, relative = true }),
            { repeating = true, description = "Shrink width" })
    end
    for _, k in ipairs({ "J", "down" }) do
        hl.bind(k, hl.dsp.window.resize({ x = 0, y = 30, relative = true }),
            { repeating = true, description = "Grow height" })
    end
    for _, k in ipairs({ "K", "up" }) do
        hl.bind(k, hl.dsp.window.resize({ x = 0, y = -30, relative = true }),
            { repeating = true, description = "Shrink height" })
    end
    for _, k in ipairs({ "L", "right" }) do
        hl.bind(k, hl.dsp.window.resize({ x = 30, y = 0, relative = true }),
            { repeating = true, description = "Grow width" })
    end

    hl.bind("Return", hl.dsp.submap("reset"), { description = "Exit resize mode" })
    hl.bind("Escape", hl.dsp.submap("reset"), { description = "Exit resize mode" })
    hl.bind("ALT + R", hl.dsp.submap("reset"), { description = "Exit resize mode" })
end)

----------------------
---- WINDOW RULES ----
----------------------

-- Float rules. bin/float-window appends/removes anonymous rules of exactly the
-- shape below, so keep that formatting on one line if you edit these by hand.
hl.window_rule({ match = { class = "blueman-manager" }, float = true })
hl.window_rule({ match = { class = "yad", title = "yad-calendar" }, float = true })
-- float-window confirmation dialog (bin/float-window)
hl.window_rule({ match = { class = "yad", title = "Float window" }, float = true })
