{ inputs, overlays, linuxOverlays, ... }:

let
	lib = inputs.nixpkgs.lib;
in
lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
		{
			nixpkgs.overlays = overlays ++ linuxOverlays;

			# Modules
			gui.enable							= true;
			steam.enable						= true;
			laptop.enable						= true;
			"8bitdo".enable						= true;
			nvidia.enable						= false;
			amdgpu.enable						= false;

			networking.hostName = "lord";

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

				../../modules
				../../modules/linux
				./hardware-configuration.nix
				inputs.home-manager.nixosModules.home-manager
			];
		}
	];
}
