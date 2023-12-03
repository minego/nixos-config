{ lib, config, osConfig, ... }:
with lib;

{
	imports = [
		./kitty
		./zsh

		./dwl
		./waybar
		./swaync
		./xenon-colorscheme
	] ++ lib.optionals osConfig.gui.enable [
		./fonts
	];
}
