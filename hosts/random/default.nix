{ inputs, globals, overlays, darwinOverlays, ... }:

inputs.darwin.lib.darwinSystem rec {
	system = "aarch64-darwin";

	modules = [
		{
			nixpkgs.overlays = overlays ++ darwinOverlays;

			# Modules
			gui.enable			= false;

			networking.hostName	= "random";

			imports = [
				../../users/m/darwin.nix
				../../modules
				../../modules/darwin
				inputs.home-manager.darwinModules.home-manager
			];
		}
	];
}
