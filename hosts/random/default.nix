{ inputs, overlays, darwinOverlays, ... }:

inputs.darwin.lib.darwinSystem rec {
	system = "aarch64-darwin";

	modules = [
		{
			nixpkgs.overlays = overlays ++ darwinOverlays;

			# Modules
			gui.enable			= true;

			networking.hostName	= "random";

			imports = [
				../../users/m/darwin.nix
				../../modules/common.nix
				../../modules/darwin/common.nix
				inputs.home-manager.darwinModules.home-manager
			];
		}
	];
}
