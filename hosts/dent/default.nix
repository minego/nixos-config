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
			amdgpu.enable	= true;
			nvidia.enable	= false;

			# Enable networking, with DHCP and a bridge device
			networking.hostName = "dent";

			networking.useDHCP = false;
			networking.interfaces.enp42s0.useDHCP = true;
			networking.interfaces.br0.useDHCP = true;
			networking.bridges = {
				"br0" = {
					interfaces = [ "enp42s0" ];
				};
			};

			time.timeZone = "America/Denver";

			services.fstrim.enable = lib.mkDefault true;

			home-manager = {
				useGlobalPkgs	= true;
				useUserPackages	= true;
			};

			imports = [
				../../modules
				../../users/m
				./hardware-configuration.nix
				inputs.home-manager.nixosModules.home-manager
			];
		}
	];
}
