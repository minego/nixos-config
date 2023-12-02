{ inputs, overlays, ... }:

let
	lib = inputs.nixpkgs.lib;
in
lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
		{
			nixpkgs.overlays = overlays;
			# Turn on all features related to desktop and graphical applications
			gui.enable		= false;
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

			time.timeZone = "America/Denver";

			home-manager = {
				useGlobalPkgs	= true;
				useUserPackages	= true;
			};

			imports = [
				../../modules
				../../modules/services
				../../users/m
				./hardware-configuration.nix
				inputs.home-manager.nixosModules.home-manager
			];
		}
	];
}
