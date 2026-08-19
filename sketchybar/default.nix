{ ... }:
{
	xdg.configFile = {
		"sketchybar/sketchybarrc".source           = ./sketchybarrc;
		"sketchybar/style.sh".source               = ./style.sh;
		"sketchybar/plugins/battery.sh".source     = ./plugins/battery.sh;
		"sketchybar/plugins/datetime.sh".source    = ./plugins/datetime.sh;
		"sketchybar/plugins/hover.sh".source       = ./plugins/hover.sh;
		"sketchybar/plugins/media.sh".source       = ./plugins/media.sh;
		"sketchybar/plugins/spaces.sh".source      = ./plugins/spaces.sh;
		"sketchybar/plugins/volume.sh".source      = ./plugins/volume.sh;
		"sketchybar/plugins/volume_popup.sh".source = ./plugins/volume_popup.sh;
		"sketchybar/plugins/wifi.sh".source        = ./plugins/wifi.sh;
	};
}
