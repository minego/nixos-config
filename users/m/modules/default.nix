{ lib, config, osConfig, ... }:
with lib;

{
	imports = [

	] ++ lib.optionals osConfig.gui.enable [
		./fonts
		./kitty

		./dwl
		./waybar
		./swaync
	];
}
