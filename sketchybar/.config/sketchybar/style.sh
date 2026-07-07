#!/usr/bin/env bash
# Shared style: colors (mirror colors/light.yaml) + bar geometry.
# Format: 0xAARRGGBB, AA=ff opaque.

export BASE=0xfffaf9f7   # true background (special role, not an ANSI slot)
export BG=0xffeeedea     # slot 15 (dim_bg) / inactive surface + border
export HL_BG=0xffdfe0d9  # slot 7  (bg)     / active surface (focused space)
export FG=0xff4b505b     # slot 0  (fg)
export DIM=0xffaaa9a4    # slot 8  (dim_fg) / active window border

export RED=0xffd05858     
export GREEN=0xff608e32   
export YELLOW=0xffbe7e05  
export BLUE=0xff5079be 
export MAGENTA=0xffb05ccc 
export CYAN=0xff3a8b84    

export TRANSPARENT=0x00000000

HEIGHT=32

# shared bracket style
bracket=(
background.color=$BASE
background.corner_radius=20
background.height=$HEIGHT
background.border_color=$BG
background.border_width=2
background.padding_left=8
background.padding_right=8
)
