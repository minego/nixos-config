{ inputs, overlays, linuxOverlays, ... }:

# Gateway VM

inputs.nixpkgs.lib.nixosSystem {
	# Even if the host is aarch64, this requires p81 binaries which are not
	# available for aarch64
	system = "x86_64-linux";

	modules = [
		{
			nixpkgs.overlays = overlays ++ linuxOverlays;

			networking.hostName		= "gateway-vm";
			networking.useDHCP		= true;
		}

		{
			virtualisation.vmVariant = {
				# following configuration is added only when building VM with build-vm
				virtualisation = {
					host.pkgs			= inputs.nixpkgs.legacyPackages.aarch64-linux;
					memorySize			= 4096;
					cores				= 2;

					# We need a gui for p81
					graphics			= true;

					diskImage			= "/var/lib/libvirt/images/gateway-vm.qcow2";
					diskSize			= 4096;
				};
			};
		}
	];
}
