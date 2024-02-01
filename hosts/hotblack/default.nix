{ inputs, overlays, linuxOverlays, ... }:

let
	lib		= inputs.nixpkgs.lib;
	system	= "x86_64-linux";
	pkgs	= inputs.nixpkgs.legacyPackages.${system};
in
lib.nixosSystem {
	modules = [
		{
			nixpkgs.overlays = overlays ++ linuxOverlays;

			# Make a copy of the sources used to build the current running
			# system so it can be accessed as `/run/current-system/flake`
			system.extraSystemBuilderCmds = "ln -s ${../../.} $out/flake";

			# Enable networking, with DHCP and a bridge device
			networking.hostName						= "hotblack";
			networking.useDHCP						= false;

			# Setup a bridge to be used with libvirt
			networking.interfaces.eno1.useDHCP		= true;
			networking.interfaces.br0.useDHCP		= true;
			networking.bridges.br0.interfaces		= [ "eno1" ];

			boot.loader.efi.canTouchEfiVariables	= true;

			# Rosetta for Linux
			boot.binfmt.emulatedSystems				= [ "aarch64-linux" ];

			imports = [
				../../users/m/linux.nix

				../../modules/common.nix
				../../modules/linux/common.nix
				../../modules/linux/printer.nix
				../../modules/linux/interception-tools.nix
				../../modules/linux/libvirt.nix
				../../modules/linux/nvidia.nix
				../../modules/linux/builders.nix

				../../modules/services
				./hardware-configuration.nix
				inputs.home-manager.nixosModules.home-manager
			];

			# Remote builders and binary cache
			builders.enable							= true;
			builders.cache							= true;
			builders.dent							= true;
			builders.hotblack						= false;
			builders.zaphod							= false;

			# The printer physicall connected to this host.
			hardware.printers = {
#				ensurePrinters = [{
#					name = "Brother_HL-L2390DW";
#					location = "Home";
#					deviceUri = "usb://Brother/HL-L2390DW?serial=U64967L0N446196";
#					model = "HLL2390DW";
#				}];
			};
		}
	];
}
