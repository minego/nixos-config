{ lib, config, osConfig, ... }:
with lib;

{
	imports = [
		./firefox
	] ++ lib.optionals osConfig.gui.enable [
		./fonts
	];
}
