{ config, pkgs, lib, fetchzip, ... }:
with lib;

{
	# Options consumers of this module can set
	options.gui = {
		enable = mkEnableOption "GUI";
	};

	config = mkIf config.gui.enable {

	};
}

