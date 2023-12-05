{ inputs, globals, overlays, ... }:

inputs.darwin.lib.darwinSystem rec {
	system = "aarch64-darwin";

	modules = [
		{
			nixpkgs.overlays = overlays ++ [
				inputs.firefox-darwin.overlay
			];

			# Modules
			gui.enable			= false;
#			"8bitdo".enable		= false;
#			amdgpu.enable		= false;
#			nvidia.enable		= false;

			networking.hostName	= "random";
			time.timeZone		= "America/Denver";

			# Auto upgrade nix package and the daemon service.
			services.nix-daemon.enable = true;

			home-manager = {
				useGlobalPkgs	= true;
				useUserPackages	= true;
			};

			imports = [
				../../users/m/darwin.nix

#				../../modules
				../../modules/gui.nix
				inputs.home-manager.darwinModules.home-manager
			];
		}
	];
}
