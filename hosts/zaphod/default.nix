{ inputs, globals, overlays, ... }:

inputs.darwin.lib.darwinSystem rec {
	system = "aarch64-darwin";

	modules = [
		{
			nixpkgs.overlays = overlays;

			# Modules
			gui.enable			= true;

			networking.hostName	= "zaphod";
			time.timeZone		= "America/Denver";

			# Auto upgrade nix package and the daemon service.
			services.nix-daemon.enable = true;

			home-manager = {
				useGlobalPkgs	= true;
				useUserPackages	= true;
			};

			imports = [
				../../users/m/darwin.nix
				../../modules
				../../modules/darwin
				inputs.home-manager.darwinModules.home-manager
			];
		}
	];
}
