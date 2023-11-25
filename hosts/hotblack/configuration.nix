{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
    ];

	networking.hostName = "hotblack";
	time.timeZone = "America/Denver";
}
