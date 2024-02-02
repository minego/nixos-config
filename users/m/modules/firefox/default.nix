{ config, pkgs, lib, osConfig, ... }:
with lib;

{
	# All other configuration is handled in the main firefox module
	xdg.configFile."tridactyl/tridactylrc".source = ./../../dotfiles/tridactylrc;
}
