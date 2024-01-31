{ lib, config, osConfig, ... }:
with lib;

{
	imports = [
		./xenon-colorscheme
		./kitty
		./zsh
		./firefox

		./karabiner
	] ++ lib.optionals osConfig.gui.enable [
		./fonts
	];
}
