{ inputs, overlays, ... }:

let
	pkgs	= inputs.nixpkgs;
	lib		= inputs.nixpkgs.lib;
in
lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
		../../modules
		../../modules/services
		../../users/m.nix
		./hardware-configuration.nix
		inputs.home-manager.nixosModules.home-manager

		{
			# Turn on all features related to desktop and graphical applications
			gui.enable		= false;
			"8bitdo".enable	= false;
			nvidia.enable	= true;

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
		}
	];
}
