{ config, pkgs, lib, osConfig, ... }:
with lib;

{
	config = mkIf (osConfig.gui.enable) {
		programs.kitty = {
			settings = {
			};
		};
	};
}
