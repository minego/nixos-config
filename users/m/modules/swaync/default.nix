{ config, pkgs, lib, osConfig, ... }:
with lib;

{
	config = mkIf (config.dwl.enable && osConfig.gui.enable) {
		home.packages = with pkgs; [
			swaynotificationcenter
		];

		home.file = {
			".config/swaync/config.json".source		= ./config.json;
			".config/swaync/style.css".source		= ./style.css;
		};
	};
}
