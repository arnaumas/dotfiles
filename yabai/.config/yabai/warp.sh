#!/usr/bin/env sh
export PATH="/opt/homebrew/bin:$PATH"
dir="$1"

# 1. reposition within the current display
yabai -m window --warp "$dir" && exit 0

# 2. floating window: nudge, don't cross displays
if [ "$(yabai -m query --windows --window | jq -r '."is-floating"')" = "true" ]; then
	case "$dir" in
		west)  yabai -m window --move rel:-20:0 ;;
		east)  yabai -m window --move rel:20:0  ;;
		north) yabai -m window --move rel:0:-20 ;;
		south) yabai -m window --move rel:0:20  ;;
	esac
	exit 0
fi

# 3. managed window at the edge: send it to the adjacent display and follow,
#    landing against the shared edge (east -> leftmost, west -> rightmost).
#    a relocated window goes through the same leaf selection as a new one
#    (send_window_to_space -> view_add_window_node), which reads
#    window_insertion_point. setting it up front decides the slot at insert
#    time, so nothing has to reposition the window afterwards. the default,
#    focused, would key the landing to whatever was focused over there.
#    two knobs, not one: window_insertion_point picks which leaf gets split,
#    window_placement picks which side of that split the window takes.
case "$dir" in
	east|south) point=first; place=first_child  ;;
	west|north) point=last;  place=second_child ;;
esac

#    both values are left set afterwards rather than restored: every invocation
#    sets them, so the only cost is that windows created between warps inherit
#    the last warp's direction.
#
#    note the window still visibly jumps on arrival, and no setting here can
#    prevent it: send_window_to_space reparents the window carrying its old
#    frame, and only tiles it afterwards, so it is briefly drawn at its
#    position on the source display. window_animation_duration makes that
#    second step read as motion instead of a glitch.
yabai -m config window_insertion_point "$point"
yabai -m config window_placement "$place"
yabai -m window --display "$dir" --focus
