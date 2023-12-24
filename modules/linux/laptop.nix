{ config, pkgs, lib, ... }:
with lib;

{
	config = mkIf (config.laptop.enable) {
		environment.systemPackages = with pkgs; [
			acpi
		];

		# Don't shutdown if someone hits the power button!
		services.logind.extraConfig = ''
            HandlePowerKey=ignore
        '';
	};
}
