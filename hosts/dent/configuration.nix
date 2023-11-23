{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
	];

	networking.hostName = "dent";
	time.timeZone = "America/Denver";
}
