{ inputs, overlays, linuxOverlays, ... }:

inputs.nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
		{
			nixpkgs.overlays = overlays ++ linuxOverlays ++ [
				# Patch DWL to enable adaptive sync
				(final: prev: {
					dwl = prev.dwl.overrideAttrs(old: {
						patches = [
							./dwl.patch
						];
					});
				})
			];

			# Modules
			gui.enable							= true;
			steam.enable						= true;
			"8bitdo".enable						= true;
			amdgpu.enable						= true;
			nvidia.enable						= false;
			samba.enable						= true;
			webdav.enable						= true;

			services.fstrim.enable				= true;
			interception-tools.enable			= true;

			# Enable networking, with DHCP and a bridge device
			networking.hostName		= "dent";

			networking.useDHCP		= false;

			# Setup a bridge to be used with libvirt
			networking.interfaces.enp42s0.useDHCP = true;
			networking.interfaces.br0.useDHCP = true;
			networking.bridges.br0.interfaces = [ "enp42s0" ];

			boot.loader.efi.canTouchEfiVariables = true;

			imports = [
				../../users/m/linux.nix

				../../modules
				../../modules/linux
				./hardware-configuration.nix
				inputs.home-manager.nixosModules.home-manager
			];
		}
	];
}
