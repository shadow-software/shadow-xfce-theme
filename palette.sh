#!/usr/bin/env bash
# The Shadow palette — one source for the GTK theme, the window manager, the
# terminal and the widgets.
#
# Values are the Shadow Software brand, not an invention:
# shadowsoftware.com `marketing/THE-ESSENCE.md` section 6 —
#   "Palette: #060606, #0d0d0d, green #8fd468 as glow/accent never fill,
#    text #ededed. Mood: dark, precise, discreet. Anti: neon cyberpunk."
# The greens below are that accent and its two derived states; everything else
# is a neutral step between #060606 and #ededed.

SHADOW_NAME="Shadow"

# Ground — darkest to lightest
SHADOW_BG_0="#060606"   # deepest ground: window manager frames, terminal
SHADOW_BG_1="#0d0d0d"   # app background
SHADOW_BG_2="#151515"   # raised surface: headerbars, sidebars
SHADOW_BG_3="#1e1e1e"   # controls at rest
SHADOW_BG_4="#2a2a2a"   # hover / borders

# Ink
SHADOW_FG="#ededed"     # primary text
SHADOW_FG_DIM="#8b8e84" # secondary text
SHADOW_FG_MUTE="#5c5f58" # disabled

# Accent — glow, never a fill of large areas
SHADOW_ACCENT="#8fd468"
SHADOW_ACCENT_DIM="#7fc358"
SHADOW_ACCENT_DEEP="#463608"

# States
SHADOW_WARN="#e0b657"
SHADOW_ERROR="#d4756b"
SHADOW_OK="#9de073"

# Opacity for the shell background, and for the window frame via the compositor.
#
# The frame PNGs are ALWAYS fully opaque. xfwm4 derives the frame's input shape
# from the theme images, so a pixel that is not fully opaque is treated as
# outside the window — a translucent title bar stops receiving clicks entirely
# and the titlebar becomes undraggable and its buttons dead, while still being
# drawn. Frame translucency belongs to the compositor
# (xfwm4 /general/frame_opacity), which leaves the input region intact.
SHADOW_ALPHA="${SHADOW_ALPHA:-0.96}"

# Terminal ANSI 0-15, built from the same steps
SHADOW_ANSI=(
  "#151515" "#d4756b" "#8fd468" "#e0b657" "#7fb2ff" "#a98fd4" "#68d4c4" "#b3b6ad"
  "#5c5f58" "#e08c84" "#9de073" "#eccb84" "#9fc9ff" "#c2aee6" "#8fe0d4" "#ededed"
)
