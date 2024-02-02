{ lib, config, osConfig, ... }:
with lib;

{
	imports = [
		./xenon-colorscheme
		./kitty
		./firefox

		./karabiner
	] ++ lib.optionals osConfig.gui.enable [
		./fonts
	];
}
