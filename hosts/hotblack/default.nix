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

			nix.registry.nixpkgs.flake			= inputs.nixpkgs;
			nix.nixPath							= [ "nixpkgs=${inputs.nixpkgs}" ];

			# Make a copy of the sources used to build the current running
			# system so it can be accessed as `/run/current-system/flake`
			system.extraSystemBuilderCmds = "ln -s ${../../.} $out/flake";

			# Enable networking, with DHCP and a bridge device
			networking.hostName						= "hotblack";
			networking.useDHCP						= false;

			# Setup a bridge to be used with libvirt
			networking.interfaces.eno1.useDHCP		= false;
			networking.interfaces.br0.useDHCP		= true;
			networking.bridges.br0.interfaces		= [ "eno1" ];

			# A hostId is needed for zfs
			# A new unique ID can be generated with:
			#	`head -c4 /dev/urandom | od -A none -t x4`
			networking.hostId						= "9d5bbde4";

			# Disable TCPSegmentationOffload and GenericSegmentationOffload for
			# the e1000 network card.
			#
			# When those are on the card in this machine behaves badly, and
			# will randomly stop responding to network requests for a few
			# seconds at a time.
			systemd.services.fixNetwork-e1000 = {
				wantedBy	= [ "multi-user.target"	];
				after		= [ "network.target"	];
				description	= "Disable ethernet segmentation offload";
				script		= "${pkgs.ethtool}/bin/ethtool -K eno1 tso off gso off";
			};

			# Set options recommended by tailscale
			systemd.services.fixNetwork-tailscale = {
				wantedBy	= [ "multi-user.target"	];
				after		= [ "network.target"	];
				description	= "Set options on br0 recommended by tailscale";
				script		= "${pkgs.ethtool}/bin/ethtool -K br0 rx-udp-gro-forwarding on rx-gro-list off ";
			};

			boot.loader.efi.canTouchEfiVariables	= true;

			# Rosetta for Linux
			boot.binfmt.emulatedSystems				= [ "aarch64-linux" ];

			# ZFS support
			boot.supportedFilesystems				= [ "zfs" ];
			boot.zfs.forceImportRoot				= false;
			services.zfs.autoScrub.enable			= true;

			# This machine acts as a tailscale exit node
			services.tailscale = {
				useRoutingFeatures					= lib.mkForce "both";
				extraUpFlags						= [
					"--advertise-exit-node"
					"--advertise-routes=172.31.0.0/16"
				];
			};

			imports = [
				../../users/m/linux.nix

				../../modules/common.nix
				../../modules/tailscale.nix
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

			age.secrets = {
				hotblack-dashboard-env = {
					file							= ../../secrets/hotblack-dashboard-env.age;
					owner							= "root";
					group							= "users";
					mode							= "400";
				};
			};
		}

		inputs.agenix.nixosModules.default
	];
}
