{ pkgs, lib, ... }:
with lib;

{
	config = mkIf config.gui.enable {

	};
}

