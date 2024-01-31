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

		jovian.decky-loader.user				= config.me.user;

		steamdeck.enable						= mkDefault true;
		jovian = {
			steam = {
				enable							= mkDefault true;
				autoStart						= mkDefault true;
				user							= config.me.user;

				desktopSession					= "dwl";
			};

			devices.steamdeck = {
				enable							= mkDefault true;
				autoUpdate						= mkDefault true;
				enableKernelPatches				= mkDefault true;
			};
		};

		environment.systemPackages = with pkgs; [
			mangohud
			steamdeck-firmware
			jupiter-dock-updater-bin
		];
	};
}
