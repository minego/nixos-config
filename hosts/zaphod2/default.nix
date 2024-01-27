{ inputs, overlays, linuxOverlays, ... }:

let
	lib = inputs.nixpkgs.lib;
in
lib.nixosSystem {
	system = "aarch64-linux";
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
					dwl = prev.dwl.overrideAttrs(old: {
						patches = old.patches ++ [
							./dwl.patch
						];
					});
				})
			];

			# Make the top bar taller to hide the notch if needed
			hasNotch							= true;

			# Modules
			gui.enable							= true;
			steam.enable						= false;
			laptop.enable						= true;
			"8bitdo".enable						= true;

			nvidia.enable						= false;
			amdgpu.enable						= false;

			interception-tools.enable			= true;

			# Remote builders and binary cache
			builders.enable						= true;
			builders.cache						= true;
			builders.dent						= true;
			builders.hotblack					= true;
			builders.zaphod						= false;

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

			services.fstrim.enable				= lib.mkDefault true;

			boot = {
				extraModprobeConfig				= "options hid_apple iso_layout=0 swap_fn_leftctrl=1 fnmode=2";
				kernelParams					= [ "apple_dcp.show_notch=1" ];
			};

			services.tlp.enable					= true;

			imports = [
				../../users/m/linux.nix

				../../modules
				../../modules/linux
				inputs.home-manager.nixosModules.home-manager

				./hardware-configuration.nix
				inputs.apple-silicon.nixosModules.apple-silicon-support
			];
		}
	];
}
