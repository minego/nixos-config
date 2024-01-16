{ inputs, overlays, linuxOverlays, ... }:

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

				usePredictableInterfaceNames	= false;
				interfaces.eth0.ipv4.addresses = [{
					address						= "192.168.122.1";
					prefixLength				= 24;
				}];
				defaultGateway					= "192.168.122.0";
				nameservers						= [ "8.8.8.8" "1.1.1.1" ];
			};

			# Modules
			gui.enable							= false;
			steam.enable						= false;
			"8bitdo".enable						= false;
			amdgpu.enable						= false;
			nvidia.enable						= false;
			samba.enable						= false;

			bios.enable							= true;

			# Bootloader.
			boot.loader.grub.enable				= true;
			boot.loader.grub.device				= "/dev/vda";

			environment.systemPackages = [
				inputs.p81.packages.x86_64-linux.p81
			];

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
