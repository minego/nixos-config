{ pkgs, config, lib, ... }:

{
	config = {
		services.displayManager.autoLogin = {
			enable								= true;
			user								= config.me.user;
		};

		# Disable regreet - Jovian uses greetd, but with its own greeter
		programs.regreet.enable					= lib.mkForce false;

		jovian.decky-loader.user				= config.me.user;

		jovian = {
			steam = {
				enable							= lib.mkDefault true;
				autoStart						= lib.mkDefault true;
				user							= config.me.user;

				desktopSession					= "dwl";
			};

			devices.steamdeck = {
				enable							= lib.mkDefault true;
				autoUpdate						= lib.mkDefault true;
				enableKernelPatches				= lib.mkDefault true;
			};

			steamos.useSteamOSConfig			= lib.mkDefault true;
		};

		# The Steam Deck UI integrates with NetworkManager
		networking.networkmanager.enable		= true;
		networking.wireless.enable				= false;

		environment.systemPackages = with pkgs; [
			acpi
			mangohud
			steamdeck-firmware
			jupiter-dock-updater-bin
			chiaki4deck
		];
	};
}
