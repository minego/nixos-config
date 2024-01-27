{ inputs, overlays, linuxOverlays, ... }:

let
	lib = inputs.nixpkgs.lib;
	pkgs = inputs.nixpkgs.legacyPackages.aarch64-linux;
in
lib.nixosSystem {
	system = "aarch64-linux";
	modules = [
		{
			nixpkgs.overlays = overlays
			++ linuxOverlays
			++ [
				(import "${inputs.sxmo-nix}/overlay.nix")
			];

			# Modules
			gui.enable							= true;
			steam.enable						= false;
			laptop.enable						= true;
			"8bitdo".enable						= false;

			nvidia.enable						= false;
			amdgpu.enable						= false;

			interception-tools.enable			= false;

			networking.hostName					= "marvin";
			networking.networkmanager.enable	= true;

			services.fstrim.enable				= lib.mkDefault true;

			powerManagement.enable				= true;
			services.upower.enable				= true;
			hardware.opengl.enable				= true;

			builders.enable						= true;
			builders.zaphod						= true;

			# The phone uses tow-boot, not systemd-boot
			boot.loader.systemd-boot.enable		= lib.mkForce false;

			imports = [
				./hardware-configuration.nix
				./phone.nix
				../../users/m/linux.nix

				../../modules
				../../modules/linux
				inputs.home-manager.nixosModules.home-manager

				(import "${inputs.sxmo-nix}/module.nix")

				(import "${inputs.mobile-nixos}/lib/configuration.nix" {
					device = "pine64-pinephonepro";
				})
			];
		}
	];
}
