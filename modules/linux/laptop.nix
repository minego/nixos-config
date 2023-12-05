{ pkgs, ... }:
{
	services.thermald.enable	= true;
	services.tlp.enable			= true;

	environment.systemPackages = with pkgs; [
		acpi
	];
}
