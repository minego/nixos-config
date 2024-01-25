{ pkgs, config, lib, ... }:
with lib;

{
	config = {
		mobile.beautification = {
			silentBoot						= mkForce false;
			splash							= mkForce false;
		};

		# sxmo
		services.xserver = {
			enable							= true;
			desktopManager.sxmo.enable		= true;

			displayManager = {
				# power->toggle WM in sxmo only works with tinytm
				tinydm.enable				= true;

				autoLogin.enable			= true;
				autoLogin.user				= "m";

				# Xorg
				# defaultSession				= "sxmo";

				# Wayland
				defaultSession				= "swmo";
			};
		};

		# It is a phone...
		environment.systemPackages			= with pkgs; [
			chatty
			megapixels
		];
		programs.calls.enable				= true;

		# GPS
		services.geoclue2.enable			= true;
		users.users.geoclue.extraGroups		= [ "networkmanager" ];

		# Sensors
		hardware.sensor.iio.enable			= true;
		hardware.firmware					= [
			config.mobile.device.firmware
		];

		# Enable power management options
		powerManagement.enable				= true;

		# Marvin only has 4GB of memory
		zramSwap.enable						= true;

		mobile.boot.stage-1.firmware = [
			config.mobile.device.firmware
		];

		services.fwupd.enable				= true;


		users.users."m" = {
			extraGroups = [
				"dialout"
				"feedbackd"
				"networkmanager"
				"video"
				"wheel"
			];
		};
	};
}

