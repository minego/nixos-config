{ config, pkgs, lib, inputs, ... }:

{
	# Enable support for printing
	services.printing = {
		enable = true;
		drivers = [ pkgs.brlaser pkgs.hll2390dw-cups ];
	};

#	hardware.printers = {
#		ensurePrinters = [{
#			name = "Brother_HL-L2390DW";
#			location = "Home";
#			deviceUri = "usb://Brother/HL-L2390DW?serial=U64967L0N446196";
#			model = "HLL2390DW";
#		}];
#	};

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
