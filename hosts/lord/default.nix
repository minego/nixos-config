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

			networking.hostName = "lord";

			# Enable Network Manager
			networking.networkmanager.enable = true;
			programs.nm-applet.enable = true;

			time.timeZone = "America/Denver";
			boot.initrd.luks.devices."luks-7c93fd91-b48e-49bb-9de9-28832248b424".device = "/dev/disk/by-uuid/7c93fd91-b48e-49bb-9de9-28832248b424";

			services.fstrim.enable = lib.mkDefault true;
		}
	];
}
