{ lib, config, osConfig, ... }:
with lib;

{
	imports = [
		./xenon-colorscheme
		./kitty
		./zsh
		./firefox

		./waybar
		./karabiner
	] ++ lib.optionals osConfig.gui.enable [
		./fonts
	];
}
