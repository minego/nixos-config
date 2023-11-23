{ config, pkgs, lib, inputs, ... }:

let
	caps2escPkg	= pkgs.interception-tools-plugins.caps2esc;

	swapmods = pkgs.stdenv.mkDerivation rec {
		name		= "swapmods";
		version		= "0.0.1";
		makeFlags	= [ "CFLAGS=-O1" ];

		src = pkgs.fetchFromGitHub {
			owner	= "minego";
			repo	= "swapmods";
			rev		= "b71ef5f4300622edf41cc43771d87ab2bd24cd3d";
			sha256	= "sha256-NX2Fs3BiEHszmAjFjdFU9rLG7zEBpa3xakZiuCwJ458=";
		};

		installPhase = ''
			mkdir -p $out/bin
			cp swapmods $out/bin/
		'';

		meta = with lib; {
			homepage	= "https://github.com/minego/swapmods";
			description	= "Swap alt and super";
			license		= licenses.asl20; # Apache-2.0
			platforms	= platforms.linux;
		};
	};

	mackeys = pkgs.stdenv.mkDerivation rec {
		name		= "mackeys";
		version		= "0.0.1";
		makeFlags	= [ "CFLAGS=-O3" ];

		src = pkgs.fetchFromGitHub {
			owner	= "minego";
			repo	= "mackeys";
			rev		= "9e55b1bd4bd9b02c80383abe8a2b83bcd6e6f8ce";
			sha256	= "sha256-eKjlK5decabLKBCDPMfSVxOBFPVU+ejxLt1doPvF4G4=";
		};

		installPhase = ''
			mkdir -p $out/bin
			cp mackeys $out/bin/
		'';

		meta = with lib; {
			homepage	= "https://github.com/minego/mackeys";
			description	= "Allow using super with x,c,v for consistent copy and paste everywhere";
			license		= licenses.asl20; # Apache-2.0
		};
	};
in
{
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
    NAME: ".*((k|K)(eyboard|EYBOARD)).*"
		'';
	};
}
