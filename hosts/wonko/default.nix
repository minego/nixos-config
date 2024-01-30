{ inputs, overlays, linuxOverlays, ... }:

let
	lib = inputs.nixpkgs.lib;
in
inputs.nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
		"${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
		inputs.jovian-nixos.nixosModules.default

		{
			nixpkgs.overlays = overlays ++ linuxOverlays ++ [
				# Add host specific overlays here
			];

			# Modules
			steamdeck.enable						= true;
			jovian.devices.steamdeck.enable			= true;

			# Enable networking, with DHCP and a bridge device
			networking.hostName						= "wonko";
			networking.useDHCP						= false;

			boot.loader.efi.canTouchEfiVariables	= true;

			imports = [
				../../users/m/linux.nix

				../../modules/common.nix
				../../modules/linux/common.nix
				../../modules/linux/gui.nix
				../../modules/linux/printer.nix
				../../modules/linux/8bitdo.nix
				../../modules/linux/interception-tools.nix
				# ../../modules/linux/libvirt.nix
				# ../../modules/linux/amdgpu.nix
				../../modules/linux/steam.nix
				../../modules/linux/builders.nix
				../../modules/linux/syncthing.nix

				../../modules/linux/steamdeck.nix
				inputs.home-manager.nixosModules.home-manager
			];

			# Remote builders and binary cache
			builders.enable							= true;
			builders.cache							= false;
			builders.dent							= true;
			builders.hotblack						= true;
			builders.zaphod							= false;
		}
	];
}
