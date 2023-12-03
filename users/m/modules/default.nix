{ lib, config, osConfig, ... }:
with lib;

{
	imports = [
		./kitty

		./dwl
		./waybar
		./swaync
		./xenon-colorscheme
	] ++ lib.optionals osConfig.gui.enable [
		./fonts
	];
}
