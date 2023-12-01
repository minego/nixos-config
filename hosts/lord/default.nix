{ inputs, overlays, ... }:

let
	lib = inputs.nixpkgs.lib;
in
lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
		{
			nixpkgs.overlays = overlays;

			# Modules
			gui.enable		= true;
			"8bitdo".enable	= true;
			nvidia.enable	= false;
			amdgpu.enable	= false;

			networking.hostName = "lord";

			# Enable Network Manager
			networking.networkmanager.enable = true;
			programs.nm-applet.enable = true;

			time.timeZone = "America/Denver";
			boot.initrd.luks.devices."luks-7c93fd91-b48e-49bb-9de9-28832248b424".device = "/dev/disk/by-uuid/7c93fd91-b48e-49bb-9de9-28832248b424";

			services.fstrim.enable = lib.mkDefault true;

			imports = [
				../../modules
				../../users/m.nix
				./hardware-configuration.nix
				inputs.home-manager.nixosModules.home-manager
			];
		}
	];

	nix.buildMachines = [{
		hostName	= "dent";
		system		= "x86_64-linux";
		protocol	= "ssh-ng";

		maxJobs		= 3;
		speedFactor	= 2;
		supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
		mandatoryFeatures = [ ];
	}];

	nix.distributedBuilds = true;
}
