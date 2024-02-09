{ inputs, overlays, linuxOverlays, ... }:

let
	lib		= inputs.nixpkgs.lib;
	system	= "x86_64-linux";
	pkgs	= inputs.nixpkgs.legacyPackages.${system};
in
lib.nixosSystem {
	modules = [
		{
			nixpkgs.overlays = overlays ++ linuxOverlays;

			# Make a copy of the sources used to build the current running
			# system so it can be accessed as `/run/current-system/flake`
			system.extraSystemBuilderCmds = "ln -s ${../../.} $out/flake";

			networking.hostName					= "lord";

			# Gavin likes gnome
			services.xserver = {
				enable							= true;
				displayManager.gdm.enable		= true;
				desktopManager.gnome.enable		= true;
			};

			# Enable Network Manager
			networking.networkmanager.enable	= true;
			programs.nm-applet.enable			= true;

			boot.initrd.luks.devices."luks-7c93fd91-b48e-49bb-9de9-28832248b424".device = "/dev/disk/by-uuid/7c93fd91-b48e-49bb-9de9-28832248b424";
			services.fstrim.enable				= lib.mkDefault true;

			boot.loader.efi.canTouchEfiVariables= true;
			
			# This isn't available on aarch64, so I'm including it here instead
			# of in laptop.nix
			services.thermald.enable			= true;

			imports = [
				../../users/m/linux.nix
				../../users/gavin/linux.nix

				../../modules/common.nix
				../../modules/tailscale.nix
				../../modules/linux/common.nix
				../../modules/linux/gui.nix
				../../modules/linux/printer.nix
				../../modules/linux/8bitdo.nix
				../../modules/linux/steam.nix
				../../modules/linux/laptop.nix

				./hardware-configuration.nix
				inputs.home-manager.nixosModules.home-manager
			];
		}
	];
}
