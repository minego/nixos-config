{ inputs, overlays, ... }:

inputs.nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
		{
			nixpkgs.overlays		= overlays;

			# Modules
			gui.enable				= true;
			"8bitdo".enable			= true;
			amdgpu.enable			= true;
			nvidia.enable			= false;

			time.timeZone			= "America/Denver";
			services.fstrim.enable	= true;

			# Enable networking, with DHCP and a bridge device
			networking.hostName		= "dent";

			networking.useDHCP		= false;

			# Setup a bridge to be used with libvirt
			networking.interfaces.enp42s0.useDHCP = true;
			networking.interfaces.br0.useDHCP = true;
			networking.bridges.br0.interfaces = [ "enp42s0" ];

			home-manager = {
				useGlobalPkgs	= true;
				useUserPackages	= true;
			};

			imports = [
				../../users/m/linux.nix

				../../modules
				./hardware-configuration.nix
				inputs.home-manager.nixosModules.home-manager
			];
		}
	];
}
