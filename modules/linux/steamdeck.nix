{ pkgs, config, lib, ... }:
with lib;

{
	# Options consumers of this module can set
	options.steamdeck = {
		enable = mkEnableOption "Steam Deck";
	};

	config = mkIf (config.steamdeck.enable && pkgs.stdenv.isLinux) {
		services.xserver.displayManager.autoLogin = {
			enable								= true;
			user								= config.me.user;
		};

		jovian.steam.autoStart					= true;
		jovian.steam.user						= config.me.user;
		jovian.decky-loader.user				= config.me.user;
		jovian.steam.desktopSession				= "dwl";

		environment.systemPackages = with pkgs; [
			steamdeck-firmware
		];
	};
}
