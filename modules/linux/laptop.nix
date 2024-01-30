{ config, pkgs, lib, ... }:
with lib;

{
	environment.systemPackages = with pkgs; [
		acpi
	];

	# Don't shutdown if someone hits the power button!
	services.logind.extraConfig = ''
		HandlePowerKey=ignore
	'';
}
