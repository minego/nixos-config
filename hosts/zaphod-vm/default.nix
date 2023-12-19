{ inputs, overlays, linuxOverlays, ... }:

# This VM was setup following this guide:
#		https://www.tweag.io/blog/2023-02-09-nixos-vm-on-macos/
#
# This can be built/started with
#		nix run .#zaphod-vm
#
# Starting this from macOS will require a Linux box to build some portions, so
# the simplest solution is to start an aarch64 linux VM to use to bootstrap:
#		https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder
#

inputs.nixpkgs.lib.nixosSystem {
	system = "aarch64-linux";
	modules = [
		{
			nixpkgs.overlays		= overlays ++ linuxOverlays;

			# A handful of things aren't available on arm, so...
			nixpkgs.config.allowUnsupportedSystem = true;

			# TODO Turn on the kernel option to be able to run x86 apps on arm

			virtualisation.vmVariant.virtualisation = {
				graphics			= true;
				host.pkgs			= inputs.nixpkgs.legacyPackages.aarch64-darwin;

				cores				= 8;
				memorySize			= 32768;
				diskSize			= 204800;

				guestAgent.enable	= true;
			};

			# Modules
			gui.enable				= true;

			laptop.enable			= false;
			steam.enable			= false;

			"8bitdo".enable			= false;
			amdgpu.enable			= false;
			nvidia.enable			= false;

			services.fstrim.enable	= true;

			# Enable networking, with DHCP and a bridge device
			networking.hostName		= "zaphod-vm";

			networking.useDHCP		= false;
			networking.interfaces.eth0.useDHCP = true;

			services.getty.autologinUser = "m";

			imports = [
				../../users/m/linux.nix

				../../modules
				../../modules/linux
				inputs.home-manager.nixosModules.home-manager
			];
		}
	];
}
