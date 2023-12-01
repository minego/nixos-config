{ config, pkgs, lib, inputs, ... }:

{
	nix.buildMachines = [
		{
			hostName	= "dent";
			system		= "x86_64-linux";
			protocol	= "ssh-ng";

			maxJobs		= 3;
			speedFactor	= 2;
			supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
			mandatoryFeatures = [ ];
		}
	];

	nix.distributedBuilds = true;
}
