{ inputs, overlays, linuxOverlays, lib, ... }:
with lib;

# Gateway VM

inputs.nixpkgs.lib.nixosSystem {
	# Even if the host is aarch64, this requires p81 binaries which are not
	# available for aarch64
	system = "x86_64-linux";

	modules = [
		{
			nixpkgs.overlays = overlays ++ linuxOverlays;

			networking = {
				hostName						= "gateway-vm";
				networkmanager.enable			= true;
			};
			programs.nm-applet.enable			= true;

			# Modules
			gui.enable							= false;
			steam.enable						= false;
			"8bitdo".enable						= false;
			amdgpu.enable						= false;
			nvidia.enable						= false;
			samba.enable						= false;

			p81.enable							= true;

			# Bootloader.
			boot.loader.systemd-boot.enable		= mkForce false;

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

				../../modules
				../../modules/linux
				inputs.home-manager.nixosModules.home-manager

				./hardware-configuration.nix
			];
		}
	];
}
