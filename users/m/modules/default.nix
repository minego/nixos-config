{ lib, config, osConfig, ... }:
with lib;

{
	imports = [
		./kitty
		./zsh
		./firefox

		./dwl
		./waybar
		./swaync
		./xenon-colorscheme
	] ++ lib.optionals osConfig.gui.enable [
		./fonts
	];
}
