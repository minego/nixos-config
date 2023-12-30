{ inputs, overlays, linuxOverlays, ... }:

# Gateway VM
#
# https://astro.github.io/microvm.nix/declaring.html

inputs.nixpkgs.lib.nixosSystem {
	# Even if the host is aarch64, this requires p81 binaries which are not
	# available for aarch64
	system = "x86_64-linux";

	modules = [
		inputs.microvm.nixosModules.microvm

		{
			networking.hostName		= "gateway-vm";
			networking.useDHCP		= true;

			microvm = {
				# hypervisor		= "cloud-hypervisor";

				vcpu				= 1;
				mem					= 4096;

				interfaces = [{
					type			= "bridge";
					id				= "vm-a1";
				}];
			};

			# Modules
			gui.enable				= true;

			laptop.enable			= false;
			steam.enable			= false;
			"8bitdo".enable			= false;
			amdgpu.enable			= false;
			nvidia.enable			= false;

			imports = [
				../../users/m/linux.nix

				../../modules
				../../modules/linux
				inputs.home-manager.nixosModules.home-manager
			];
		}
	];
}
