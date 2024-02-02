{ lib, config, osConfig, ... }:
with lib;

{
	imports = [
		./xenon-colorscheme
		./kitty

		./karabiner
	] ++ lib.optionals osConfig.gui.enable [
		./fonts
	];
}
