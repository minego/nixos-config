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
			firefox
		];


		services.xserver.displayManager.session = [{
			manage									= "desktop";
			name									= "dwl";
			start = ''
                ${pkgs.dwl}/bin/dwl &
                waitPID=$!
                '';
		}];

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
					suspend							= [ "systemctl" "suspend" ];
					reboot							= [ "systemctl" "reboot" ];
					poweroff							= [ "systemctl" "poweroff" ];
				};
			};
		};
	};
}

