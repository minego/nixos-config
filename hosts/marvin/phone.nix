{ pkgs, config, lib, ... }:
with lib;

{
	config = {
		# Temporary experiments with phosh
		services.xserver.desktopManager.phosh = {
			enable							= true;
			user							= "m";

			group							= "users";
			# for better compatibility with x11 applications
			phocConfig.xwayland				= "immediate";
		};

		# It is a phone...
		environment.systemPackages			= with pkgs; [
			chatty
			megapixels
		];
		programs.calls.enable				= true;
		systemd.services.ModemManager.serviceConfig.ExecStart = [
			# clear ExecStart from upstream unit file.
			"${pkgs.modemmanager}/sbin/ModemManager --test-quick-suspend-resume"
		];

		# GPS
		services.geoclue2.enable			= true;
		users.users.geoclue.extraGroups		= [ "networkmanager" ];

		# Sensors
		hardware.sensor.iio.enable			= true;
		hardware.firmware					= [
			config.mobile.device.firmware
		];

		mobile.boot.stage-1.firmware = [
			config.mobile.device.firmware
		];

		services.fwupd.enable				= true;
	};
}

