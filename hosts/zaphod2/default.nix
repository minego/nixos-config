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

				# Patch DWL to enable scaling
				(final: prev: {
					dwl = prev.dwl.overrideAttrs(old: {
						patches = old.patches ++ [
							./dwl.patch
						];
					});
				})
			];

			# Modules
			gui.enable							= true;
			steam.enable						= false;
			laptop.enable						= true;
			"8bitdo".enable						= true;

			nvidia.enable						= false;
			amdgpu.enable						= false;

			interception-tools.enable			= true;

			# Turn on the asahi GPU driver
			hardware.asahi.useExperimentalGPUDriver = true;
			hardware.opengl = {
				enable							= true;
				driSupport						= true;
			};

			networking.hostName					= "zaphod2";

			# Enable Network Manager
			networking.networkmanager.enable	= true;
			programs.nm-applet.enable			= true;

			services.fstrim.enable				= lib.mkDefault true;

			# This should be false with asahi!
			boot.loader.efi.canTouchEfiVariables= false;
			boot.extraModprobeConfig			= "options hid_apple iso_layout=0 swap_fn_leftctrl=1 fnmode=2";

			# Rosetta for Linux
			boot.binfmt.emulatedSystems			= [ "x86_64-linux" ];

			# Reference the firmware required for asahi
			hardware.asahi.peripheralFirmwareDirectory = ../../firmware;

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
