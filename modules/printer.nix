{ config, pkgs, lib, inputs, ... }:

{
	# Enable support for scanners
	hardware.sane = {
		enable = true;
		brscan5.enable = true;
		brscan4.enable = true;
		extraBackends = [ pkgs.sane-airscan ];
	};

	users.users.m.extraGroups = [ "scanner" "lp" ];
	services.ipp-usb.enable = true;
}
