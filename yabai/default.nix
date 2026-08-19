{ ... }:
{
	xdg.configFile = {
		"yabai/yabairc".source              = ./yabairc;
		"yabai/layer.sh".source             = ./layer.sh;
		"yabai/lib.sh".source               = ./lib.sh;
		"yabai/on_display_added.sh".source  = ./on_display_added.sh;
		"yabai/on_display_removed.sh".source = ./on_display_removed.sh;
		"yabai/padding.sh".source           = ./padding.sh;
		"yabai/scratchpad.sh".source        = ./scratchpad.sh;
		"yabai/send_display.sh".source      = ./send_display.sh;
		"yabai/send_space.sh".source        = ./send_space.sh;
		"yabai/snapshot.sh".source          = ./snapshot.sh;
		"yabai/warp.sh".source              = ./warp.sh;
	};
}
