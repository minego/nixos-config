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
		./karabiner
	] ++ lib.optionals osConfig.gui.enable [
		./fonts
	];
}
