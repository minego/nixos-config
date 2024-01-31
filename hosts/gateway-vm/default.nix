{ inputs, overlays, linuxOverlays, ... }:

# Gateway VM
let
	# Even if the host is aarch64, this requires p81 binaries which are not
	# available for aarch64
	system	= "x86_64-linux";

	lib		= inputs.nixpkgs.lib;
	pkgs	= inputs.nixpkgs.legacyPackages.${system};
in
lib.nixosSystem {
	modules = [
		{
			nixpkgs.overlays = overlays ++ linuxOverlays;

			networking = {
				hostName						= "gateway-vm";
				networkmanager.enable			= true;
			};
			programs.nm-applet.enable			= true;

			# Bootloader.
			boot.loader.systemd-boot.enable		= lib.mkForce false;

			# Bootloader.
			boot.loader.grub.enable				= true;
			boot.loader.grub.device				= "/dev/vda";

			services.xserver = {
				enable							= true;
				desktopManager = {
					xterm.enable				= false;
					xfce.enable					= true;
				};
				displayManager.defaultSession	= "xfce";
			};

			# VM Options
			virtualisation.vmVariant = {
				# following configuration is added only when building VM with build-vm
				virtualisation = {
					memorySize			= 4096;
					cores				= 2;

					# We need a gui for p81
					graphics			= true;

					diskImage			= "/var/lib/libvirt/images/gateway-vm.qcow2";
					diskSize			= 4096;
				};
			};

			imports = [
				# "${inputs.nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

				../../users/m/linux.nix

				../../modules/common.nix
				../../modules/linux/common.nix
				../../modules/linux/gui.nix
				../../modules/linux/builders.nix

				../../modules/linux/p81.nix

				inputs.home-manager.nixosModules.home-manager

				./hardware-configuration.nix
			];
		}
	];
}
