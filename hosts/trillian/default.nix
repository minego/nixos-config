{ inputs, overlays, linuxOverlays, ... }:

let
	lib		= inputs.nixpkgs.lib;
	system	= "x86_64-linux";
	pkgs	= inputs.nixpkgs.legacyPackages.${system};
in
lib.nixosSystem {
	modules = [
		{
			# Make a copy of the sources used to build the current running
			# system so it can be accessed as `/run/current-system/flake`
			system.extraSystemBuilderCmds = "ln -s ${../../.} $out/flake";

			nixpkgs.overlays = overlays ++ linuxOverlays ++ [
				# Add host specific overlays here
			];

			# Enable networking, with DHCP and a bridge device
			networking.hostName						= "trillian";
			networking.useDHCP						= false;

			# Enable Network Manager
			networking.networkmanager.enable	= true;
			programs.nm-applet.enable			= true;

			boot.loader.efi.canTouchEfiVariables	= true;

			imports = [
				../../modules/common.nix
				../../modules/tailscale.nix
				../../modules/linux/common.nix
				../../modules/linux/gui.nix
				../../modules/linux/dwl.nix
				../../modules/linux/printer.nix
				../../modules/linux/8bitdo.nix
				../../modules/linux/interception-tools.nix
				../../modules/linux/libvirt.nix
				../../modules/linux/steam.nix
				../../modules/linux/builders.nix
				../../modules/linux/syncthing.nix

				../../users/m/linux.nix
				inputs.home-manager.nixosModules.home-manager

				./hardware-configuration.nix
			];

			# Remote builders and binary cache
			builders.enable							= true;
			builders.cache							= false;
			builders.dent							= true;
			builders.hotblack						= true;
			builders.zaphod							= false;

			nixpkgs.hostPlatform					= system;
		}
	];
}
