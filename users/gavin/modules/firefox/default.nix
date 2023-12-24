{ config, pkgs, lib, osConfig, ... }:
with lib;

{

	options = {
		firefox = {
			enable = lib.mkEnableOption {
				description		= "Enable Firefox.";
				default			= false;
			};
		};
	};

	config = lib.mkIf (osConfig.gui.enable && config.firefox.enable) {
		programs.firefox = {
			enable				= true;

			package				=
				if
					pkgs.stdenv.isDarwin
				then
					pkgs.firefox-bin
				else
					pkgs.firefox-wayland;
		};

		xdg.mimeApps = mkIf pkgs.stdenv.isLinux {
			enable = true;

			defaultApplications = {
				"text/html"					= "firefox.desktop";
				"x-scheme-handler/http"		= "firefox.desktop";
				"x-scheme-handler/https"	= "firefox.desktop";
				"x-scheme-handler/about"	= "firefox.desktop";
				"x-scheme-handler/unknown"	= "firefox.desktop";
			};
		};

		home.sessionVariables = {
			KEYTIMEOUT		= "1";
			LC_CTYPE		= "C";
		};
	};
}
