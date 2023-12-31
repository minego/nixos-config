{ inputs, overlays, linuxOverlays, ... }:

inputs.nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
		{
			nixpkgs.overlays = overlays ++ linuxOverlays;

			# Turn off all features related to desktop and graphical applications
			gui.enable		= false;
			printer.enable	= false;
			"8bitdo".enable	= false;
			amdgpu.enable	= false;

			# This machine doesn't run a gui but it does have an Nvidia GPU
			nvidia.enable	= true;

			# Enable networking, with DHCP and a bridge device
			networking.hostName = "hotblack";

			networking.useDHCP = false;

			networking.interfaces.eno1 = {
				useDHCP = true;
			};
			networking.interfaces.br0 = {
				useDHCP = true;
			};

			networking.bridges = {
				"br0" = {
					interfaces = [ "eno1" ];
				};
			};

			binary-cache.enable					= true;
			# Use these systems as a binary cache
			nix.settings.substituters = [
				"ssh://nix-ssh@dent.minego.net"
			];


			boot.loader.efi.canTouchEfiVariables = true;

			imports = [
				../../users/m/linux.nix

				../../modules
				../../modules/linux
				../../modules/services
				./hardware-configuration.nix
				inputs.home-manager.nixosModules.home-manager
			];
		}
	];
}
