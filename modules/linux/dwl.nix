{ pkgs, config, lib, ... }:
with lib;

{
	config = {
		environment.systemPackages = with pkgs; [
			dwl
			wayland
			wlr-randr

			wdisplays
			pavucontrol
			pamixer

			kitty
		];

		services.xserver.displayManager.sessionPackages = [
			pkgs.dwl-unwrapped
			pkgs.dwl-services
		];

		services.greetd = {
			enable									= mkDefault true;
		};

		programs.regreet = {
			enable									= mkDefault true;

			settings = {
				GTK = {
					application_prefer_dark_theme	= true;
				};

				commands = {
					reboot							= [ "systemctl" "reboot" ];
					poweroff						= [ "systemctl" "poweroff" ];
				};
			};
		};
	};
}

