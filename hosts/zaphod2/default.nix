{ inputs, overlays, linuxOverlays, ... }:

let
	lib = inputs.nixpkgs.lib;
	system = "aarch64-linux";
in
lib.nixosSystem {
	inherit system;

	modules = [
		{
			nixpkgs.overlays = overlays
			++ linuxOverlays
			++ [
				inputs.apple-silicon.overlays.apple-silicon-overlay
				(final: prev: {
					mesa = final.mesa-asahi-edge;
				})

				# Patch DWL to enable scaling
				(final: prev: {
					dwl-unwrapped = inputs.dwl-minego-customized.packages.${system}.dwl-unwrapped.overrideAttrs(old: {
						patches = old.patches ++ [
							./dwl.patch
						];
					});
				})
			];

			# Make the top bar taller to hide the notch if needed
			hasNotch							= true;

			# Turn on the asahi GPU driver
			hardware = {
				asahi = {
					addEdgeKernelConfig			= true;
					peripheralFirmwareDirectory	= ./firmware;
					useExperimentalGPUDriver	= true;
					experimentalGPUInstallMode	= "driver";
					withRust					= true;
				};
				opengl = {
					enable						= true;
					driSupport					= true;
				};
			};


			networking.hostName					= "zaphod2";

			# Enable Network Manager
			networking.networkmanager.enable	= true;
			programs.nm-applet.enable			= true;

			boot = {
				extraModprobeConfig				= "options hid_apple iso_layout=0 swap_fn_leftctrl=1 fnmode=2";
				kernelParams					= [ "apple_dcp.show_notch=1" ];
			};

			services.tlp.enable					= true;

			imports = [
				../../users/m/linux.nix

				../../modules/common.nix
				../../modules/linux/common.nix
				../../modules/linux/gui.nix
				# ../../modules/linux/printer.nix
				../../modules/linux/8bitdo.nix
				../../modules/linux/interception-tools.nix
				../../modules/linux/libvirt.nix
				# ../../modules/linux/steam.nix
				../../modules/linux/builders.nix
				../../modules/linux/syncthing.nix
				../../modules/linux/laptop.nix

				inputs.home-manager.nixosModules.home-manager

				./hardware-configuration.nix
				inputs.apple-silicon.nixosModules.apple-silicon-support
			];

			# Remote builders and binary cache
			builders.enable						= true;
			builders.cache						= true;
			builders.dent						= true;
			builders.hotblack					= true;
			builders.zaphod						= false;
		}
	];
}
