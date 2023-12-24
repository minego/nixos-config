{ config, pkgs, lib, ... }:
with lib;

{
	config = mkIf (config.laptop.enable) {
		services.tlp.enable			= true;

		environment.systemPackages = with pkgs; [
			acpi
		];
	};
}
