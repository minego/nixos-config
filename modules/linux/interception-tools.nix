{ config, pkgs, lib, inputs, ... }:

let
	caps2escPkg	= pkgs.interception-tools-plugins.caps2esc;
	swapmods	= pkgs.minego.swapmods;
	mackeys		= pkgs.minego.mackeys;
in
{
	# Interception-Tools
	services.interception-tools = {
		enable = false;
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
    NAME: ".*((k|K)(eyboard|EYBOARD)).*"
'';
	};
}
