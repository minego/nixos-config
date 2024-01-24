{ inputs, overlays, linuxOverlays, ... }:

let
	lib = inputs.nixpkgs.lib;
	pkgs = inputs.nixpkgs.legacyPackages.aarch64-linux;
in
lib.nixosSystem {
	system = "aarch64-linux";
	modules = [
		{
			nixpkgs.overlays = overlays
			++ linuxOverlays
			++ [
				# Add host specific overlays here
			];

			# Modules
			gui.enable							= true;
			steam.enable						= false;
			laptop.enable						= true;
			"8bitdo".enable						= false;

			nvidia.enable						= false;
			amdgpu.enable						= false;

			interception-tools.enable			= false;

			networking.hostName					= "marvin";

			services.fstrim.enable				= lib.mkDefault true;

			powerManagement.enable				= true;
			hardware.opengl.enable				= true;

			systemd.defaultUnit					= "graphical.target";
			systemd.services.phosh = {
				wantedBy						= [ "graphical.target" ];
				serviceConfig = {
					ExecStart					= "${pkgs.phosh}/bin/phosh";
					User						= 1000;
					PAMName						= "login";
					WorkingDirectory			= "~";

					TTYPath						= "/dev/tty7";
					TTYReset					= "yes";
					TTYVHangup					= "yes";
					TTYVTDisallocate			= "yes";

					StandardInput				= "tty-fail";
					StandardOutput				= "journal";
					StandardError				= "journal";

					UtmpIdentifier				= "tty7";
					UtmpMode					= "user";

					Restart						= "always";
				};
			};
			services.xserver.desktopManager.gnome.enable = true;

			imports = [
				../../users/m/linux.nix

				../../modules
				../../modules/linux
				inputs.home-manager.nixosModules.home-manager

				(import "${inputs.mobile-nixos}/lib/configuration.nix" {
					device = "pine64-pinephone";
				})
			];
		}
	];
}
