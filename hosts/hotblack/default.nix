{ inputs, overlays, linuxOverlays, ... }:

inputs.nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
		{
			nixpkgs.overlays = overlays ++ linuxOverlays;

			# Turn on all features related to desktop and graphical applications
			gui.enable		= false;
			printer.enable	= false;
			"8bitdo".enable	= false;
			nvidia.enable	= true;
			amdgpu.enable	= false;

			# Enable networking, with DHCP and a bridge device
			networking.hostName = "hotblack";

			networking.useDHCP = false;
			networking.interfaces.eno1.useDHCP = true;
			networking.interfaces.br0.useDHCP = true;
			networking.bridges = {
				"br0" = {
					interfaces = [ "eno1" ];
				};
			};

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
