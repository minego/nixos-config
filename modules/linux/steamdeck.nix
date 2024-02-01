{ pkgs, config, lib, ... }:
with lib;

{
	config = {
		services.xserver.displayManager.autoLogin = {
			enable								= true;
			user								= config.me.user;
		};

		# Disable regreet - Jovian uses greetd, but with its own greeter
		programs.regreet.enable					= mkForce false;

		jovian.decky-loader.user				= config.me.user;

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

		# The Steam Deck UI integrates with NetworkManager
		networking.networkmanager.enable		= true;
		networking.wireless.enable				= false;

		environment.systemPackages = with pkgs; [
			mangohud
			steamdeck-firmware
			jupiter-dock-updater-bin
		];
	};
}
