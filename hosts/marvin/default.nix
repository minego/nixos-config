{ inputs, overlays, linuxOverlays, ... }:

let
	lib		= inputs.nixpkgs.lib;
	system	= "aarch64-linux";
	# pkgs	= inputs.nixpkgs.legacyPackages.${system};
in
lib.nixosSystem {
	modules = [
		{
			nixpkgs.overlays = overlays
			++ linuxOverlays
			++ [
				(import "${inputs.sxmo-nix}/overlay.nix")
			];

			# Make a copy of the sources used to build the current running
			# system so it can be accessed as `/run/current-system/flake`
			system.extraSystemBuilderCmds = "ln -s ${../../.} $out/flake";

			networking.hostName					= "marvin";
			networking.networkmanager.enable	= true;

			powerManagement.enable				= true;
			services.upower.enable				= true;
			hardware.opengl.enable				= true;

			# The phone uses tow-boot, not systemd-boot
			boot.loader.systemd-boot.enable		= lib.mkForce false;

			imports = [
				./phone.nix
				../../users/m/linux.nix

				../../modules/common.nix
				../../modules/linux/common.nix
				../../modules/linux/gui.nix
				../../modules/linux/builders.nix
				../../modules/linux/syncthing.nix
				../../modules/linux/laptop.nix

				./hardware-configuration.nix
				inputs.home-manager.nixosModules.home-manager

				(import "${inputs.sxmo-nix}/module.nix")

				(import "${inputs.mobile-nixos}/lib/configuration.nix" {
					device = "pine64-pinephonepro";
				})
			];

			builders.enable						= true;
			builders.zaphod						= true;
		}
	];
}
