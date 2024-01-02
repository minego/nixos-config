{ inputs, overlays, linuxOverlays, ... }:

# Gateway VM

inputs.nixpkgs.lib.nixosSystem {
	# Even if the host is aarch64, this requires p81 binaries which are not
	# available for aarch64
	system = "x86_64-linux";

	modules = [
		{
			nixpkgs.overlays = overlays ++ linuxOverlays;

			networking.hostName			= "gateway-vm";
			networking.useDHCP			= true;

			# Modules
			gui.enable					= false;
			steam.enable				= false;
			"8bitdo".enable				= false;
			amdgpu.enable				= false;
			nvidia.enable				= false;
			samba.enable				= false;

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
				../../users/m/linux.nix

				../../modules
				../../modules/linux
				inputs.home-manager.nixosModules.home-manager
			];
		}
	];
}
