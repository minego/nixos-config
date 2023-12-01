{ inputs, overlays, ... }:

let
	pkgs	= inputs.nixpkgs;
	lib		= inputs.nixpkgs.lib;
in
lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
		../../modules
		../../users/m.nix
		./hardware-configuration.nix
		inputs.home-manager.nixosModules.home-manager

		{
			nixpkgs.overlays = overlays;

			# Modules
			gui.enable		= true;
			"8bitdo".enable	= true;
			amdgpu.enable	= true;

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
		}
	];
}
