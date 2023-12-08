{ lib, config, osConfig, ... }:
with lib;

{
	imports = [
		./xenon-colorscheme
		./kitty
		./zsh
		./firefox

		./dwl
		./waybar
		./swaync
		./karabiner
	] ++ lib.optionals osConfig.gui.enable [
		./fonts
	];
}
