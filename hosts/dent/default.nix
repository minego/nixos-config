{ inputs, overlays, linuxOverlays, ... }:

let
	lib		= inputs.nixpkgs.lib;
	system	= "x86_64-linux";
	pkgs	= inputs.nixpkgs.legacyPackages.${system};
in
lib.nixosSystem {
	modules = [
		{
			nixpkgs.overlays = overlays ++ linuxOverlays ++ [
				# Patch DWL to enable adaptive sync
				(final: prev: {
					dwl-unwrapped = inputs.dwl-minego-customized.packages.${system}.dwl-unwrapped.overrideAttrs(old: {
						patches = [ ./dwl.patch ];
					});
				})
			];

			nix.registry.nixpkgs.flake			= inputs.nixpkgs;
			nix.nixPath							= [ "nixpkgs=${inputs.nixpkgs}" ];

			# Make a copy of the sources used to build the current running
			# system so it can be accessed as `/run/current-system/flake`
			system.extraSystemBuilderCmds = "ln -s ${../../.} $out/flake";

			# Enable networking, with DHCP and a bridge device
			networking.hostName						= "dent";
			networking.useDHCP						= false;

			# Setup a bridge to be used with libvirt
			networking.interfaces.enp42s0.useDHCP	= false;
			networking.interfaces.br0.useDHCP		= true;
			networking.bridges.br0.interfaces		= [ "enp42s0" ];

			boot.loader.efi.canTouchEfiVariables	= true;

			# Rosetta for Linux
			boot.binfmt.emulatedSystems				= [ "aarch64-linux" ];

			imports = [
				../../users/m/linux.nix

				../../modules/common.nix
				../../modules/tailscale.nix
				../../modules/linux/common.nix
				../../modules/linux/gui.nix
				../../modules/linux/dwl.nix
				../../modules/linux/printer.nix
				../../modules/linux/8bitdo.nix
				../../modules/linux/interception-tools.nix
				../../modules/linux/libvirt.nix
				../../modules/linux/amdgpu.nix
				../../modules/linux/steam.nix
				../../modules/linux/builders.nix
				../../modules/linux/luks-ssh.nix
				../../modules/linux/syncthing.nix

				./hardware-configuration.nix
				inputs.home-manager.nixosModules.home-manager
			];

			# Remote builders and binary cache
			builders.enable							= true;
			builders.cache							= true;
			builders.zaphod							= true;

			# Enable remote LUKS unlocking
			luks-ssh = {
				enable								= true;
				modules								= [ "r8169" ];
			};
		}

		# Build and start a macOS VM
		inputs.nixtheplanet.nixosModules.macos-ventura {
			services.macos-ventura = {
				enable				= false;

				openFirewall		= true;
				vncListenAddr		= "0.0.0.0";
				sshPort				= 2222;
				vncDisplayNumber	= 1;
				mem					= "12G";

				# cores				= 16;
				# sockets				= 2;

				dataDir				= "/var/lib/nixtheplanet-macos-ventura";
			};
		}
	];
}
