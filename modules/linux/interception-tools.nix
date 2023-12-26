{ config, pkgs, lib, inputs, ... }:
with lib;

let
	caps2escPkg	= pkgs.interception-tools-plugins.caps2esc;
	swapmods	= pkgs.minego.swapmods;
	mackeys		= pkgs.minego.mackeys;
in
{
	options = {
		interception-tools = {
			enable = mkEnableOption "Interception Tools";
		};
	};

	config = mkIf config.interception-tools.enable {
		# Interception-Tools
		services.interception-tools = {
			enable = true;
			plugins = [
				caps2escPkg
				mackeys
				swapmods
			];
			udevmonConfig = ''
- JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${swapmods}/bin/swapmods | ${mackeys}/bin/mackeys | ${caps2escPkg}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
  DEVICE:
    NAME: AT Translated Set 2 keyboard
- JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${mackeys}/bin/mackeys | ${caps2escPkg}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
  DEVICE:
    NAME: Apple MTP keyboard
- JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${mackeys}/bin/mackeys | ${caps2escPkg}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
  DEVICE:
    NAME: ".*((k|K)(eyboard|EYBOARD)).*"
'';
		};
	};
}
