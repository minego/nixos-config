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
	};
}

