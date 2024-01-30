{ pkgs, config, lib, inputs, ... }:
with lib;

{
	config = mkIf pkgs.stdenv.isLinux {
		# Enable support for printing
		services.printing = {
			enable = true;
			drivers = [ pkgs.brlaser pkgs.hll2390dw-cups ];
		};

		# Enable support for scanners
		hardware.sane = {
			enable = true;
			brscan5.enable = true;
			brscan4.enable = true;
			extraBackends = [ pkgs.sane-airscan ];
		};

		users.users.m.extraGroups = [ "scanner" "lp" ];
		services.ipp-usb.enable = true;
	};
}
